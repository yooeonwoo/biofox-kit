---
title: "ComfyUI로 Seedance 2.5 영상을 만드는 실행 경로"
type: synthesis
status: seed
tags: [AI, 창작, 바이오폭스]
aliases: [ComfyUI Seedance 실행]
created: 2026-08-17
updated: 2026-08-17
---

# ComfyUI로 Seedance 2.5 영상을 만드는 실행 경로

## 질의
이 환경에서 ComfyUI + Seedance 2.5로 영상을 바로 만들 수 있는가.

## 답
가능하다. 조건은 로컬 GPU가 아니라 **이미 떠 있는 ComfyUI + Comfy.org 로그인 + Partner Node 크레딧**이다. 2026-08-17 기준으로 그 조건은 살아 있다.

## 실측 (2026-08-17)

| 항목 | 상태 |
|------|------|
| ComfyUI | `~/ComfyUI` · `127.0.0.1:8188` · 0.33.0 · 큐 비어 있음 |
| 노드 | `ByteDance2TextToVideoNode` / `FirstLastFrame` / `ReferenceNode` 로드됨 |
| 모델 ID | `dreamina-seedance-2-5-260628` |
| 인증 | 오늘 `ByteDance2ReferenceNode` 30초 잡이 success |
| 실패 | history에 error 2건. 노드 부재가 아니라 프롬프트/정책/크레딧 쪽 |

더마노바 쪽 워크플로 원본은 `~/Downloads/edit/dermanova_seedance25/workflows/`에 있다. 주력은 레퍼런스 이미지+영상 → `ByteDance2ReferenceNode`.

바이오폭스 브랜드필름은 아직 Higgsfield 경로로 공식화되어 있다. ComfyUI는 같은 2.5를 다른 API 문으로 부르는 실행 레이어다. Higgsfield MCP는 이 세션에서 auth 실패.

## 만들 때 쓰는 모드

1. **T2V** — 프롬프트만. 프로토타입·무드 테스트.
2. **FLF2V** — 시작/끝 스틸 고정. 클립 조인트.
3. **R2V** — 제품·공간·모션 레퍼런스 고정. 브랜드/기업 필름 주력.
4. **Video editing / extend** — 기존 클립 수정·앞뒤 연장.

2.5 연출 규칙([[바이오폭스 시네마틱 브랜드필름 공식 — 명품 2분 문법 × Seedance 2.5 역행 스토리라인]]): 한 패스 최대 30초, 샷당 ≥3초, 클립당 ≤5샷, 카메라 무브 1–2개, 채택은 마지막 20초를 보고.

## 다음 액션
프롬프트 또는 레퍼런스 이미지만 주면 `8188`에 워크플로를 넣고 결과를 `~/ComfyUI/output/`에서 회수하면 된다.

## Connections
- ComfyUI Seedance 2.5는 로컬 가중치가 아니라 Partner Node API다
- [[바이오폭스 시네마틱 브랜드필름 공식 — 명품 2분 문법 × Seedance 2.5 역행 스토리라인]]
- [[BIOFOX 과학 다큐 영상 서사 설계 — 성장인자 직접재생 다이브]]
- [[BIOFOX 영상은 단백질 기술을 과학 CG가 아니라 클리니컬 제품 무드로 전달해야 한다]]
- AI 영상 생성 비용은 초 단위로 설계해야 한다
- 이미지 에이전트와 영상 에이전트는 같은 프롬프트를 쓰면 안 된다
