# BIOFOX·피부과학 팀 위키 — 운영 규칙

이 폴더는 팀이 함께 쓰는 LLM Wiki다. AI가 읽고, 종합하고, 다시 적립해서 쓸수록 쌓이는 지식 베이스다.
Obsidian에서 이 폴더를 볼트로 열어도 된다.

## 구조

```
03 Resources/Brands/  — 원본 자료 (브랜드 캐논·컴플라이언스·제품 설명). 읽기만 한다
50 Wiki/              — 원자 노트 (1노트 = 1주장)
  ├ 피부과학/          — 피부장벽·성장인자·노화·색소·시술 후 관리
  ├ 바이오폭스/        — 제품·브랜드·영업·운영
  ├ 마케팅/            — BIOFOX 관련 마케팅 원칙
  ├ _index.md         — 마스터 허브
  ├ _log.md           — 작업 기록
  └ MOC - *.md        — 주제 지도
60 Synthesis/         — 여러 노트를 종합한 분석·결정 기록
70 Output/            — 산출물 (매거진 원고·브리프)
```

## 읽을 때

`50 Wiki/_index.md` → 주제 MOC → 원자 노트 순으로 탐색한다. `60 Synthesis/` 에 이미 답이 있는지 먼저 본다.

## 쓸 때 (지키지 않으면 적립이 아니다)

1. **dead link 금지** — `[[링크]]`는 실제로 있는 노트에만 건다.
2. **중복 금지** — 새 노트를 만들기 전에 같은 주제 폴더를 훑는다. 같은 내용이 있으면 기존 노트를 보강한다.
3. **등재** — 새 노트는 관련 MOC에 링크하고, Synthesis는 `_index.md` 카탈로그 표에 1줄 추가한다. 등재 안 된 노트는 없는 노트다.
4. **기록** — `_log.md` 에 `## [YYYY-MM-DD] ingest|query|lint | 제목` 형식으로 한 줄 남긴다.
5. **원본 불변** — `03 Resources/` 는 수정하지 않는다.

## 노트 형식

```markdown
---
title: "하나의 주장문"
type: zettel          # zettel | moc | synthesis | reference | output
status: seed          # seed → growing → evergreen
tags: []              # 2~5개
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# 제목 (하나의 주장문)

## Main Idea
핵심을 내 말로.

## Context
왜 중요한지.

## Connections
- [[관련 노트]] — 연결 이유
```

## 내용 기준

- 제품 효능·수치·임상 결과는 근거가 있는 것만 적는다.
- 화장품 광고 표현 규칙은 `03 Resources/Brands/BIOFOX 컴플라이언스·콘텐츠 규칙.md` 를 따른다.
- 개인 정보, 계정·비밀번호·토큰은 위키에 적지 않는다.
