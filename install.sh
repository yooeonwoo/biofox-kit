#!/usr/bin/env bash
# biofox-kit installer
# Installs the team skills, agents and the BIOFOX·피부과학 knowledge wiki into Claude Code and Codex.
# Works on macOS /bin/bash 3.2, Linux bash, and Git Bash on Windows.
# Usage: ./install.sh [--only claude,codex] [--copy] [--skip-plugins] [--no-instructions]
#                     [--update] [--dry-run] [--uninstall] [-h]
set -uo pipefail

KIT_ROOT="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P)"
KIT_LINK="$HOME/.biofox-kit"                  # stable path; the wiki skill reads the wiki through it
LEDGER="$HOME/.biofox-kit.installed"          # what this installer created: "<path>\t<fingerprint>"
MARK=".biofox-kit"                            # marker file placed inside copied directories
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
CLAUDE_DIR="${CLAUDE_DIR%/}"
CODEX_DIR="${CODEX_DIR%/}"
MODE="link"                                   # link | copy
MODE_SET=0
DO_PLUGINS=1
WITH_INSTRUCTIONS=1
UNINSTALL=0
UPDATE=0
DRY=0
TARGETS=()
WARNINGS=0
SKIPPED=0
KIT_SRC="$KIT_LINK"
BLOCK_START="<!-- biofox-kit:start"           # the full line is "<!-- biofox-kit:start -->" or "... start nonl -->"
BLOCK_END="<!-- biofox-kit:end -->"
ORIG_ARGS=("$@")

usage() {
  cat <<'USAGE'
biofox-kit installer

  ./install.sh                      Claude Code / Codex 를 자동 감지해 스킬·에이전트·지식 위키를 설치
  ./install.sh --only claude        지정한 하네스에만 설치 (claude|codex, 쉼표로 여러 개)
  ./install.sh --copy               심링크 대신 복사 (Windows Git Bash 에서는 기본값)
  ./install.sh --skip-plugins       Claude Code 플러그인(deck-factory, watch) 설치를 건너뜀
  ./install.sh --no-instructions    CLAUDE.md / AGENTS.md 에 "위키 먼저 참조" 안내 블록을 넣지 않음
  ./install.sh --update             git pull 로 최신 버전을 받은 뒤 다시 설치
  ./install.sh --dry-run            실제로 바꾸지 않고 무엇을 할지만 출력
  ./install.sh --uninstall          이 스크립트가 만든 것만 제거
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy) MODE="copy"; MODE_SET=1 ;;
    --link) MODE="link"; MODE_SET=1 ;;
    --skip-plugins) DO_PLUGINS=0 ;;
    --no-instructions) WITH_INSTRUCTIONS=0 ;;
    --update) UPDATE=1 ;;
    --dry-run) DRY=1 ;;
    --uninstall) UNINSTALL=1 ;;
    --only)
      shift
      [[ -n "${1:-}" ]] || { echo "--only needs a value, e.g. --only claude,codex" >&2; exit 1; }
      IFS=',' read -r -a TARGETS <<< "$1" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

log()  { printf '\033[1;34m[kit]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[kit]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[kit] WARN\033[0m %s\n' "$*" >&2; WARNINGS=$((WARNINGS + 1)); }
die()  { printf '\033[1;31m[kit] ERROR\033[0m %s\n' "$*" >&2; exit 1; }
has()  { command -v "$1" >/dev/null 2>&1; }
dry()  { [[ $DRY -eq 1 ]]; }
in_targets() { local t; for t in ${TARGETS[@]+"${TARGETS[@]}"}; do [[ "$t" == "$1" ]] && return 0; done; return 1; }
looks_like_kit() { [[ -f "$1/install.sh" && -d "$1/skills" && -d "$1/knowledge/wiki" ]]; }

case "$(uname -s 2>/dev/null)" in
  MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=1 ;;
  *) IS_WINDOWS=0 ;;
esac
# Git Bash turns `ln -s` into a plain copy unless Developer Mode is on, so copy explicitly there.
if [[ $IS_WINDOWS -eq 1 && $MODE_SET -eq 0 ]]; then MODE="copy"; fi

# ---------- update: pull, then run the freshly pulled installer ----------
if [[ $UPDATE -eq 1 ]]; then
  has git || die "git 이 필요합니다."
  [[ -d "$KIT_ROOT/.git" ]] || die "$KIT_ROOT 는 git 저장소가 아닙니다. 처음 설치한 한 줄 명령으로 다시 받아 주세요."
  if dry; then
    log "would reset skills/ agents/ manifests/ and run git pull in $KIT_ROOT"
  else
    log "updating $KIT_ROOT"
    # skills/ agents/ manifests/ belong to the kit: some tools rewrite their own skill folder through the symlink
    # (e.g. `npx hyperframes skills update`), which would block the pull. Reset those; notes added under knowledge/ are kept.
    git -C "$KIT_ROOT" checkout -q -- skills agents manifests 2>/dev/null || true
    git -C "$KIT_ROOT" clean -fdq -- skills agents manifests 2>/dev/null || true
    git -C "$KIT_ROOT" pull --ff-only --autostash || die "git pull 실패. 네트워크와 저장소 접근 권한을 확인하세요."
    if [[ -n "$(git -C "$KIT_ROOT" ls-files -u 2>/dev/null)" ]]; then
      die "새 버전을 받았지만, $KIT_ROOT/knowledge 에서 직접 고친 노트가 새 버전과 겹쳐 충돌이 남았습니다. 'git -C $KIT_ROOT status' 로 겹친 파일을 확인해 정리한 뒤 install.sh 를 다시 실행하세요. (내 수정본은 git stash 에 보관돼 있습니다)"
    fi
  fi
  NEXT_ARGS=()
  for a in ${ORIG_ARGS[@]+"${ORIG_ARGS[@]}"}; do [[ "$a" == "--update" ]] || NEXT_ARGS+=("$a"); done
  exec "${BASH:-/bin/bash}" "$KIT_ROOT/install.sh" ${NEXT_ARGS[@]+"${NEXT_ARGS[@]}"}
fi

detect_targets() {
  if [[ ${#TARGETS[@]} -eq 0 ]]; then
    if has claude || [[ -d "$CLAUDE_DIR" ]]; then TARGETS+=(claude); fi
    if has codex  || [[ -d "$CODEX_DIR"  ]]; then TARGETS+=(codex);  fi
    if [[ ${#TARGETS[@]} -eq 0 ]]; then
      if [[ $UNINSTALL -eq 1 ]]; then TARGETS=(claude codex)   # nothing detectable any more: still clean up what the ledger knows
      else die "Claude Code 나 Codex 를 찾지 못했습니다 (claude/codex 명령, $CLAUDE_DIR, $CODEX_DIR). 먼저 설치하거나 --only 로 지정하세요."; fi
    fi
  fi
  local t
  for t in ${TARGETS[@]+"${TARGETS[@]}"}; do
    case "$t" in claude|codex) ;; *) die "unknown harness '$t' (expected claude|codex)" ;; esac
  done
}

# ---------- ledger (kept in memory, written once at exit) ----------
# NOTE: pure bash, not awk — macOS awk 20200816 mis-compares multibyte (Korean) strings passed via -v.
L_PATH=(); L_SUM=(); L_DIRTY=0; LEDGER_I=0
GONE=$'\001gone'
file_sum() { cksum < "$1" | awk '{print $1}'; }
dir_sum()  { ( cd "$1" 2>/dev/null && find . -type f ! -name "$MARK" -exec cksum {} + | LC_ALL=C sort | cksum | awk '{print $1}' ); }
ledger_load() {
  local path sum
  [[ -f "$LEDGER" ]] || return 0
  while IFS=$'\t' read -r path sum || [[ -n "$path" ]]; do
    [[ -n "$path" ]] || continue
    L_PATH+=("$path"); L_SUM+=("$sum")
  done < "$LEDGER"
}
ledger_index() {  # ledger_index <path>: sets LEDGER_I to the newest live entry; rc 1 if absent
  local i=${#L_PATH[@]}
  while [[ $i -gt 0 ]]; do
    i=$((i - 1))
    if [[ "${L_PATH[$i]}" == "$1" ]]; then
      [[ "${L_SUM[$i]}" == "$GONE" ]] && return 1
      LEDGER_I=$i; return 0
    fi
  done
  return 1
}
record()   { dry && return 0; L_PATH+=("$1"); L_SUM+=("$2");    L_DIRTY=1; }   # record <path> <fingerprint>
unrecord() { dry && return 0; L_PATH+=("$1"); L_SUM+=("$GONE"); L_DIRTY=1; }
ledger_save() {  # newest entry per path wins; removed entries are dropped
  [[ $L_DIRTY -eq 1 ]] || return 0
  local i=${#L_PATH[@]} j dup kept_p=() kept_s=()
  while [[ $i -gt 0 ]]; do
    i=$((i - 1)); dup=0
    for j in ${kept_p[@]+"${!kept_p[@]}"}; do
      if [[ "${kept_p[$j]}" == "${L_PATH[$i]}" ]]; then dup=1; break; fi
    done
    [[ $dup -eq 1 ]] && continue
    kept_p+=("${L_PATH[$i]}"); kept_s+=("${L_SUM[$i]}")
  done
  : > "$LEDGER.tmp" || return 1
  i=${#kept_p[@]}
  while [[ $i -gt 0 ]]; do
    i=$((i - 1))
    [[ "${kept_s[$i]}" == "$GONE" ]] || printf '%s\t%s\n' "${kept_p[$i]}" "${kept_s[$i]}" >> "$LEDGER.tmp"
  done
  if [[ -s "$LEDGER.tmp" ]]; then mv "$LEDGER.tmp" "$LEDGER"; else rm -f "$LEDGER.tmp" "$LEDGER"; fi
  L_DIRTY=0
}
trap ledger_save EXIT

# owned_by_kit <path>: true only for things this installer created AND that still look like what it created.
#   symlink   -> points at the kit's own entry of the same name (skills/<group>/<name> or agents/<harness>/<name>)
#   directory -> carries the marker file AND its contents still match the fingerprint recorded at install time
#   file      -> its checksum still matches the fingerprint recorded at install time
# Anything the user edited, replaced, or created themselves is therefore never removed.
owned_by_kit() {
  local dst="$1" cur base
  base="$(basename "$dst")"
  if [[ -L "$dst" ]]; then
    cur="$(readlink "$dst")"
    case "$cur" in
      "$KIT_LINK"/skills/*/"$base"|"$KIT_ROOT"/skills/*/"$base"|"$KIT_LINK"/agents/*/"$base"|"$KIT_ROOT"/agents/*/"$base") return 0 ;;
    esac
    return 1
  fi
  if [[ -d "$dst" ]]; then
    [[ -f "$dst/$MARK" ]] || return 1
    ledger_index "$dst" || return 1
    [[ "${L_SUM[$LEDGER_I]}" == "$(dir_sum "$dst")" ]]
    return
  fi
  if [[ -f "$dst" ]]; then
    ledger_index "$dst" || return 1
    [[ "${L_SUM[$LEDGER_I]}" == "$(file_sum "$dst")" ]]
    return
  fi
  return 1
}

remove_path() {  # remove_path <kit-owned path>: unlink a symlink, or delete a copied dir/file (restoring write perms first)
  local p="$1"
  if [[ -L "$p" ]]; then rm "$p" || { warn "could not remove $p"; return 1; }; return 0; fi
  if [[ -d "$p" ]]; then chmod -R u+w "$p" 2>/dev/null || true; fi
  rm -rf "$p" || { warn "could not remove $p"; return 1; }
  [[ -e "$p" ]] && { warn "could not remove $p (still present)"; return 1; }
  return 0
}

# ---------- primitive: place one skill dir or agent file ----------
place() {  # place <src-under-kit> <dst>; rc 0 = placed, 1 = skipped/failed
  local src="$1" dst="$2"
  if [[ -e "$dst" || -L "$dst" ]]; then
    if owned_by_kit "$dst"; then
      if dry; then log "would replace $dst"; else remove_path "$dst" || return 1; fi
    else
      SKIPPED=$((SKIPPED + 1))
      if [[ -f "$dst/$MARK" ]]; then warn "건너뜀: $dst (키트가 복사한 뒤 직접 고친 내용이 있어 그대로 둠)"
      else warn "건너뜀: $dst (이미 있고 키트가 만든 것이 아님)"; fi
      return 1
    fi
  fi
  if dry; then return 0; fi
  mkdir -p "$(dirname "$dst")" || { warn "cannot create $(dirname "$dst")"; return 1; }
  if [[ "$MODE" == "copy" ]]; then
    cp -R "$src" "$dst" || { warn "copy failed: $dst"; return 1; }
    if [[ -d "$dst" ]]; then
      touch "$dst/$MARK" || { warn "cannot write marker in $dst"; return 1; }
      record "$dst" "$(dir_sum "$dst")"
    else
      record "$dst" "$(file_sum "$dst")"
    fi
  else
    ln -s "$src" "$dst" || { warn "symlink failed: $dst"; return 1; }
    record "$dst" "link"
  fi
  return 0
}

forget_under() {  # forget_under <dir>: drop every ledger entry directly inside <dir> (it is no longer ours to track)
  local dir="$1" i=0 n=${#L_PATH[@]} p
  while [[ $i -lt $n ]]; do
    p="${L_PATH[$i]}"
    if [[ "$p" == "$dir"/* && "${p#"$dir"/}" != */* ]] && ledger_index "$p" && [[ $LEDGER_I -eq $i ]]; then unrecord "$p"; fi
    i=$((i + 1))
  done
  return 0
}

remove_owned_under() {  # remove_owned_under <dir>: delete kit-owned entries directly inside <dir>
  local dir="$1" e
  [[ -d "$dir" ]] || { forget_under "$dir"; return 0; }
  for e in "$dir"/* "$dir"/.[!.]*; do
    [[ -e "$e" || -L "$e" ]] || continue
    if owned_by_kit "$e"; then
      if dry; then log "would remove $e"; else remove_path "$e" || true; fi
    fi
  done
  forget_under "$dir"
  return 0
}

# ---------- skills / agents ----------
skills_root_for() {
  case "$1" in
    claude) echo "$CLAUDE_DIR/skills" ;;
    codex)  echo "$CODEX_DIR/skills" ;;
    *) return 1 ;;
  esac
}
agents_root_for() {
  case "$1" in
    claude) echo "$CLAUDE_DIR/agents" ;;
    codex)  echo "$CODEX_DIR/agents" ;;
    *) return 1 ;;
  esac
}
kit_has() {  # kit_has <harness> <skills|agents> <name>: does the kit still ship this entry?
  if [[ "$2" == "skills" ]]; then [[ -f "$KIT_SRC/skills/common/$3/SKILL.md" || -f "$KIT_SRC/skills/$1/$3/SKILL.md" ]]
  else [[ -f "$KIT_SRC/agents/$1/$3" ]]; fi
}

prune_stale() {  # prune_stale <harness> <skills|agents> <root>: remove what an older kit version installed and this one no longer ships
  local h="$1" kind="$2" root="$3" i=0 n=${#L_PATH[@]} p name
  while [[ $i -lt $n ]]; do
    p="${L_PATH[$i]}"; i=$((i + 1))
    [[ "$p" == "$root"/* && "${p#"$root"/}" != */* ]] || continue
    ledger_index "$p" || continue
    name="${p#"$root"/}"
    kit_has "$h" "$kind" "$name" && continue
    if [[ -e "$p" || -L "$p" ]]; then
      owned_by_kit "$p" || continue
      if dry; then log "would remove $p (키트에서 빠진 항목)"; continue; fi
      remove_path "$p" || continue
      log "정리: $p (키트에서 빠진 항목)"
    fi
    unrecord "$p"
  done
  return 0
}

install_skills() {
  local h="$1" root g src name n=0
  root="$(skills_root_for "$h")" || return 1
  for g in common "$h"; do
    for src in "$KIT_SRC/skills/$g"/*/; do
      src="${src%/}"
      [[ -f "$src/SKILL.md" ]] || continue
      name="$(basename "$src")"
      if place "$src" "$root/$name"; then n=$((n + 1)); fi
    done
  done
  prune_stale "$h" skills "$root"
  ok "$h: 스킬 $n개 -> $root"
}

install_agents() {
  local h="$1" src dst n=0
  dst="$(agents_root_for "$h")" || return 0
  for src in "$KIT_SRC/agents/$h"/*; do
    [[ -f "$src" ]] || continue
    if place "$src" "$dst/$(basename "$src")"; then n=$((n + 1)); fi
  done
  prune_stale "$h" agents "$dst"
  ok "$h: 에이전트 $n개 -> $dst"
}

# ---------- manifest reader: strips CR, surrounding whitespace, comments, blanks ----------
read_manifest() {  # read_manifest <file> -> lines on stdout
  local f="$1" line
  [[ -f "$f" ]] || { warn "missing manifest: $f"; return 0; }
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%$'\r'}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" || "$line" == \#* ]] && continue
    printf '%s\n' "$line"
  done < "$f"
}

# ---------- Claude Code plugins ----------
install_claude_plugins() {
  if ! has claude; then warn "claude 명령을 찾지 못해 플러그인은 건너뜁니다 (manifests/claude-plugins.txt)"; return 0; fi
  local line
  while IFS= read -r line; do
    if dry; then log "would add marketplace $line"; continue; fi
    claude plugin marketplace add "$line" </dev/null >/dev/null 2>&1 || true   # already-present is not an error
  done < <(read_manifest "$KIT_ROOT/manifests/claude-marketplaces.txt")
  while IFS= read -r line; do
    if dry; then log "would install plugin $line"; continue; fi
    if claude plugin install "$line" -s user </dev/null >/dev/null 2>&1; then ok "claude: 플러그인 $line"; else warn "플러그인 설치 실패(이미 있으면 무시): $line"; fi
  done < <(read_manifest "$KIT_ROOT/manifests/claude-plugins.txt")
  return 0
}

# ---------- instruction blocks ----------
# What append_block writes after the user's own content:  [newline if the file did not end with one] + blank line + block.
# strip_block undoes exactly that, so install → uninstall leaves the file byte-for-byte as it was.
instruction_block() {  # instruction_block <start-marker-line>
  printf '%s\n' "$1"
  cat <<'TXT'
# BIOFOX 팀 지식 위키 (biofox-kit)

피부과학·BIOFOX 바이오폭스(제품·브랜드 톤·컴플라이언스·마케팅) 관련 질문에 답하거나 글·대본·캡션을 쓰기 전에
`~/.biofox-kit/knowledge/wiki` 를 먼저 참조한다. 진입: `50 Wiki/_index.md` → `MOC - *.md` → 원자 노트.
제품 수치·효능은 위키와 `03 Resources/Brands/` 에 있는 것만 쓰고, 광고 표현은 컴플라이언스 규칙 노트를 따른다.
자세한 절차는 `biofox-wiki` 스킬과 `~/.biofox-kit/knowledge/wiki/CLAUDE.md` 참고.
TXT
  printf '%s\n' "$BLOCK_END"
}
strip_block() {  # strip_block <file>: remove our block; refuses to touch a file whose markers do not pair up. Preserves symlinks/perms.
  local f="$1" starts ends trim=0
  [[ -f "$f" ]] || return 0
  starts="$(grep -cF -- "$BLOCK_START" "$f")"
  [[ "$starts" -gt 0 ]] || return 0
  ends="$(grep -cF -- "$BLOCK_END" "$f")"
  if [[ "$starts" -ne "$ends" ]]; then
    warn "$f 의 안내 블록 시작·끝 표시가 짝이 맞지 않아 건드리지 않습니다 (직접 정리 필요)"
    return 1
  fi
  if dry; then log "would remove instruction block from $f"; return 0; fi
  # we added the final newline ourselves only if the start marker says so and nothing was written after the block
  if grep -qF -- "$BLOCK_START nonl -->" "$f" && [[ "$(tail -n 1 "$f")" == "$BLOCK_END" ]]; then trim=1; fi
  awk -v s="$BLOCK_START" -v e="$BLOCK_END" '
    function flush() { if (held) { print ""; held = 0 } }
    skipping { if (index($0, e)) skipping = 0; next }
    index($0, s) { held = 0; skipping = 1; next }      # drops the one separator blank line we put before the block
    /^$/ { flush(); held = 1; next }
    { flush(); print }
    END { flush(); if (skipping) exit 2 }' "$f" > "$f.kit.tmp" || { rm -f "$f.kit.tmp"; warn "$f 의 안내 블록을 안전하게 걷어낼 수 없어 그대로 둡니다"; return 1; }
  if [[ $trim -eq 1 ]]; then printf '%s' "$(cat "$f.kit.tmp")" > "$f.kit.tmp2" && mv "$f.kit.tmp2" "$f.kit.tmp"; fi
  cat "$f.kit.tmp" > "$f" && rm -f "$f.kit.tmp"
  # remove the file only if this installer created it and nothing else is left in it; never remove a symlink
  if [[ ! -s "$f" && ! -L "$f" ]] && ledger_index "$f" && [[ "${L_SUM[$LEDGER_I]}" == "created" ]]; then
    rm -f "$f"; unrecord "$f"
  fi
  return 0
}
append_block() {  # append_block <file>
  local f="$1" marker="$BLOCK_START -->" created=0
  if dry; then log "would add instruction block to $f"; return 0; fi
  mkdir -p "$(dirname "$f")" || { warn "cannot create $(dirname "$f")"; return 1; }
  if [[ -f "$f" ]]; then strip_block "$f" || return 1; fi
  [[ -e "$f" || -L "$f" ]] || created=1
  {
    if [[ -s "$f" ]]; then
      if [[ -n "$(tail -c 1 "$f")" ]]; then printf '\n'; marker="$BLOCK_START nonl -->"; fi
      printf '\n'
    fi
    instruction_block "$marker"
  } >> "$f" || { warn "cannot write $f"; return 1; }
  [[ $created -eq 1 ]] && record "$f" "created"
  ok "위키 안내 블록 -> $f"
}

# ---------- uninstall ----------
do_uninstall() {
  local h cur
  detect_targets
  for h in ${TARGETS[@]+"${TARGETS[@]}"}; do
    remove_owned_under "$(skills_root_for "$h")"
    remove_owned_under "$(agents_root_for "$h")"
    case "$h" in
      claude) strip_block "$CLAUDE_DIR/CLAUDE.md" || true ;;
      codex)  strip_block "$CODEX_DIR/AGENTS.md" || true ;;
    esac
  done
  if [[ -L "$KIT_LINK" ]]; then
    cur="$(readlink "$KIT_LINK")"
    if [[ "$cur" == "$KIT_ROOT" ]]; then
      if dry; then log "would remove $KIT_LINK"; else rm "$KIT_LINK"; fi
    else
      warn "$KIT_LINK 가 다른 폴더($cur)를 가리켜 그대로 둡니다"
    fi
  fi
  ledger_save
  if dry; then ok "dry-run 끝. 실제로 바뀐 것은 없습니다."
  else ok "제거 완료. Claude 플러그인(deck-factory, watch)과 키트 폴더($KIT_ROOT)는 그대로 두었습니다."; fi
}

# ---------- main ----------
ledger_load
if [[ $UNINSTALL -eq 1 ]]; then do_uninstall; exit 0; fi

looks_like_kit "$KIT_ROOT" || die "$KIT_ROOT 에 skills/ 와 knowledge/wiki 가 없습니다. 저장소 전체를 받은 뒤 그 안의 install.sh 를 실행하세요."
detect_targets
log "kit     : $KIT_ROOT"
log "targets : ${TARGETS[*]}  (mode: $MODE$( dry && printf ', dry-run' ))"

# stable path so the wiki skill can always find the wiki
if [[ "$KIT_ROOT" == "$(CDPATH= cd -- "$KIT_LINK" 2>/dev/null && pwd -P)" ]]; then
  :                                            # cloned straight into ~/.biofox-kit, or the link already points here
elif [[ -L "$KIT_LINK" ]]; then
  # repoint only a link that is dangling or that points at another checkout of this kit
  if [[ -e "$KIT_LINK" ]] && ! looks_like_kit "$KIT_LINK"; then
    die "$KIT_LINK 가 이 키트가 아닌 다른 곳($(readlink "$KIT_LINK"))을 가리킵니다. 그 링크를 옮기거나, 키트를 $KIT_LINK 에 직접 받아 실행하세요."
  fi
  if dry; then log "would repoint $KIT_LINK -> $KIT_ROOT"; else rm "$KIT_LINK" && ln -s "$KIT_ROOT" "$KIT_LINK" || die "cannot create $KIT_LINK"; fi
elif [[ -e "$KIT_LINK" ]]; then
  die "$KIT_LINK 가 이미 있는데 이 키트가 아닙니다. 그 폴더를 옮기거나, 키트를 $KIT_LINK 에 직접 받아 실행하세요."
elif [[ $IS_WINDOWS -eq 1 ]]; then
  die "Windows 에서는 키트를 $KIT_LINK 에 직접 받아야 합니다:  git clone <주소> ~/.biofox-kit && ~/.biofox-kit/install.sh"
else
  if dry; then log "would create $KIT_LINK -> $KIT_ROOT"; else ln -s "$KIT_ROOT" "$KIT_LINK" || die "cannot create $KIT_LINK"; fi
fi
# in dry-run the link may not exist yet; read sources from KIT_ROOT instead
if [[ ! -d "$KIT_LINK/skills" ]]; then KIT_SRC="$KIT_ROOT"; fi

for h in ${TARGETS[@]+"${TARGETS[@]}"}; do
  install_skills "$h"
  install_agents "$h"
done

if [[ $DO_PLUGINS -eq 1 ]] && in_targets claude; then install_claude_plugins; fi
if [[ $WITH_INSTRUCTIONS -eq 1 ]]; then
  in_targets claude && { append_block "$CLAUDE_DIR/CLAUDE.md" || true; }
  in_targets codex  && { append_block "$CODEX_DIR/AGENTS.md"  || true; }
fi
ledger_save

echo
if dry; then ok "dry-run 끝. 실제로 바뀐 것은 없습니다."; else ok "설치 끝. 지식 위키: $KIT_LINK/knowledge/wiki  (스킬: biofox-wiki)"; fi
if [[ $SKIPPED -gt 0 ]]; then printf '\033[1;33m[kit]\033[0m 같은 이름이 이미 있어 건너뛴 항목 %s개 — 기존 것을 그대로 두었습니다.\n' "$SKIPPED" >&2; fi
if [[ $WARNINGS -gt $SKIPPED ]]; then printf '\033[1;33m[kit]\033[0m 그 외 경고 %s건. 위 내용을 확인하세요.\n' "$((WARNINGS - SKIPPED))" >&2; fi
cat <<NEXT

다음: Claude Code / Codex 를 새로 열면 스킬이 잡힙니다.
업데이트:  $KIT_ROOT/install.sh --update
제거:      $KIT_ROOT/install.sh --uninstall
포함 목록: $KIT_ROOT/manifests/inventory.md
NEXT
