# biofox-kit

BIOFOX 직원용 AI 키트. 각자의 **Claude Code · Codex** 에 스킬과 BIOFOX·피부과학 지식 위키를 한 번에 설치한다.

## 설치 (한 줄)

터미널(Windows는 Git Bash)에 붙여 넣는다.

```bash
git clone https://github.com/yooeonwoo/biofox-kit.git ~/.biofox-kit && ~/.biofox-kit/install.sh
```

설치가 끝나면 Claude Code / Codex 를 새로 연다.

- 비공개 저장소라 GitHub 계정이 이 저장소에 초대되어 있어야 한다. 처음이면 `gh auth login` 으로 로그인한다.
- Claude Code 와 Codex 중 설치된 것을 자동으로 찾는다. 둘 다 있으면 둘 다에 설치한다.
- 같은 이름의 스킬을 이미 갖고 있으면 **덮어쓰지 않고 건너뛴다.**

## 들어 있는 것

| | 내용 |
|---|---|
| 스킬 | 글쓰기·마케팅(카피라이팅, SEO, 랜딩, 한글 AI 티 윤문) · 이미지(프롬프트, 대량 생성) · 영상·모션(HyperFrames, 자막, 설명 영상) · 발표·슬라이드 · 웹디자인(디자인 시스템, GSAP, three.js) |
| 에이전트 | council 토론 18 · 슬라이드 디자인 크리틱 · 한글 윤문 파이프라인 6 |
| 지식 위키 | BIOFOX 바이오폭스 + 피부과학 노트 2,000여 건. 브랜드 캐논, 컴플라이언스 규칙, 제품 설명, 마케팅 원칙, 피부과학 원자 노트 |
| 플러그인 | deck-factory(발표 덱), watch(영상 시청·분석) — Claude Code 만 |

전체 목록과 각 스킬에 따로 필요한 도구는 [`manifests/inventory.md`](manifests/inventory.md), 포함된 스킬 표는 [`manifests/skills.tsv`](manifests/skills.tsv).

## 쓰는 법

설치하면 `biofox-wiki` 스킬이 잡히고, `CLAUDE.md` / `AGENTS.md` 에 "BIOFOX·피부 질문은 위키부터 본다"는 안내가 들어간다. 그냥 평소처럼 물으면 된다.

```
큐어부스터 인스타 캡션 써줘
시술 후 24시간 관리가 왜 중요한지 고객용으로 설명해줘
이 문구 화장품 광고로 써도 되는 표현이야?
```

위키는 `~/.biofox-kit/knowledge/wiki` 에 있고, Obsidian 에서 이 폴더를 볼트로 열어 직접 읽을 수도 있다. 규칙은 그 폴더의 `CLAUDE.md`.

## 업데이트 · 제거

```bash
~/.biofox-kit/install.sh --update      # 최신 버전 받고 다시 설치
~/.biofox-kit/install.sh --uninstall   # 이 키트가 설치한 것만 제거
```

그 밖의 옵션: `--only claude` · `--copy` · `--skip-plugins` · `--no-instructions` · `--dry-run`.

- macOS / Linux 는 심링크로 설치한다. `--update` 한 번이면 내용이 바로 반영된다.
- Windows(Git Bash)는 복사로 설치한다. 내용을 갱신하려면 `--update` 를 다시 실행한다.

## 넣지 않은 것

개발용 스킬(코드 리뷰·배포·디버깅·gstack·oh-my-codex 등), 개인용 스킬, 원작자가 직접 만든 스킬은 들어 있지 않다.
지식 위키에서는 개인 메모, 회의 녹음 전사, 강의 원본 전사, 사이드 프로젝트, 앱 개발 내부 노트를 뺐다.

## 출처

스킬은 외부 공개 저장소에서 온 것이다. 출처와 라이선스는 [`NOTICE.md`](NOTICE.md). 사내 사용 목적의 묶음이므로 외부로 재배포하지 않는다.
