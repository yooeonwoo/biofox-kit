---
title: "BIOFOX GPT Image 2 카드뉴스 비주얼 하네스 — AI slop 방지 설계"
type: synthesis
status: seed
tags: [바이오폭스, 카드뉴스, 이미지생성, 디자인, AI]
query: "gpt-image-2로 BIOFOX 카드뉴스를 AI slop 없이 만들기 위한 디자인 관점의 MCP·스킬·레퍼런스·라이브러리 설계"
sources:
  - "[[BIOFOX 톤앤매너는 전문적이되 쉽고 따뜻한 권유형이다]]"
  - "[[BIOFOX 브랜드 캐논 - 절대 변하지 않는 핵심 원칙들]]"
  - "[[BIOFOX 과학 다큐 영상 서사 설계 — 성장인자 직접재생 다이브]]"
  - "[[BIOFOX 기술설명회 덱을 외부 B2B 자료로 전환할 때의 컴플라이언스 게이트와 요구사항]]"
created: 2026-07-12
updated: 2026-07-12
---

# BIOFOX GPT Image 2 카드뉴스 비주얼 하네스 — AI slop 방지 설계

## 핵심 결론

BIOFOX 카드뉴스의 AI slop은 지식 부족보다 **비주얼 문법 부재**에서 생긴다. GPT Image 2에게 “바이오 코스메틱 느낌”을 요청하면 DNA, 육각형, 네온 분자, 가짜 실험실, 과한 글로우, 랜덤 영문 라벨로 도망간다. 따라서 카드뉴스 생성 시스템에는 텍스트 RAG와 별개로 **비주얼 하네스**가 필요하다.

하네스의 기준은 다음이다.

1. BIOFOX 톤: 전문적, 신뢰 중심, 쉽고 따뜻한 권유형.
2. 시각 톤: 딥 퍼플, 실버, 네이비, 화이트. 입자감, 연결선, 바이오 분자/재조합/미래적이되 차갑지 않은 무드.
3. 영상/이미지 방향: 사람 감성 광고보다 분자·세포·피부구조의 다큐+테크니컬 연출이 BIOFOX USP에 맞음.
4. 컴플라이언스: 치료·재생 단정·의학 효능 이미지를 피하고, 교육형 메커니즘·관리 보조·컨디션 표현으로 이동.

## AI slop의 주요 원인

- “bio”, “science”, “cosmetic” 같은 단어만 던져서 모델이 클리셰를 채움.
- 한 카드 안에 텍스트, 제품, 과학, 인물, 도식, 배경을 모두 생성시키려 함.
- 카드뉴스 본문 텍스트까지 이미지 모델에게 맡김.
- 레퍼런스 이미지를 스타일명으로만 설명하고, 구체적 구조·조명·밀도·금지요소를 분리하지 않음.
- 카드별 무드가 이어지지 않고 매번 다른 세계관으로 생성됨.

## 권장 생성 구조

### 1. 텍스트와 이미지를 분리한다

카드뉴스 본문·타이포·CTA는 Remotion/HTML/CSS에서 렌더링한다. GPT Image 2는 **배경, 과학 오브젝트, 제품 없는 바이오 무드 장면**만 담당한다.

이미지 프롬프트에는 항상 다음을 넣는다.

- NO text
- NO labels
- NO letters
- NO numbers
- NO fake UI
- NO medical procedure
- NO syringe / blood / hospital scene
- NO overdramatic neon DNA

### 2. BIOFOX용 4개 비주얼 카테고리로 제한한다

1. **Bio-lab premium still life**
   - 유리 피펫, 페트리디시, 투명 앰플, 스틸 트레이, 실버 반사.
   - 목적: 전문성, 연구소 감각.

2. **Cellular / skin-structure documentary**
   - 표피층, 진피 매트릭스, 콜라겐 섬유, 미세 입자 흐름.
   - 목적: 피부과학 설명 카드.

3. **Molecular softness**
   - 단백질 폴딩, 아주 얇은 연결선, 작은 입자, 은은한 바이오루미네선스.
   - 목적: EGF/FGF 개념을 과하지 않게 암시.

4. **Clinical calm cosmetic surface**
   - 크림 텍스처, 세럼 젤, 유리, 물결, 무광 세라믹.
   - 목적: 소비자 친화, 정보형 카드.

### 3. 톤별 팔레트를 고정한다

- info: 크림/베이지/웜그레이. 브랜드 성분 언급 없이 피부 습관·장벽 정보.
- bridge: 회청록/실버/더스티 블루. 마지막에 재생인자 개념을 살짝 암시.
- conversion: 딥퍼플/네이비/실버/화이트. 10-GF·EGF/FGF 성분 개념을 정면 설명하되 브랜드명은 노출하지 않음.

## 레퍼런스 부착 방식

레퍼런스는 이미지 파일만 던지지 말고 아래 JSON처럼 붙여야 한다.

```json
{
  "reference_id": "biofox_ref_001",
  "role": "lighting_and_material",
  "keep": ["cool white lab light", "brushed metal", "deep violet glass reflection"],
  "avoid": ["neon cyberpunk", "text labels", "doctor/hospital mood"],
  "density": "low",
  "composition": "full-bleed background, center calm, edges detailed",
  "text_overlay_safe_area": "center 60% low contrast"
}
```

레퍼런스는 최소 4종으로 나눈다.

1. **색감 레퍼런스** — BIOFOX 딥퍼플/네이비/실버/화이트.
2. **재질 레퍼런스** — 유리, 피펫, 세럼, 스틸 트레이, 프로스트 글라스.
3. **과학 연출 레퍼런스** — 세포층, 콜라겐, 단백질 폴딩, 입자 흐름.
4. **레이아웃 레퍼런스** — 텍스트가 올라갈 배경 밀도, 여백, 대비.

GPT Image 2에는 한 번에 많은 레퍼런스를 섞기보다, 카드 세트 단위로 `style_ref`, `material_ref`, `science_ref`를 나누어 적용한다.

## 카드뉴스 스킬화 초안

스킬 이름 후보: `biofox-cardnews-visual-director`

### Trigger
- BIOFOX 카드뉴스 이미지 생성
- gpt-image-2 카드뉴스 배경
- 바이오 코스메틱 톤 이미지
- AI slop 없는 카드뉴스

### Skill responsibilities
1. BIOFOX 텍스트 톤과 컴플라이언스 규칙 확인.
2. 카드뉴스 톤(info/bridge/conversion) 결정.
3. 톤별 팔레트와 비주얼 카테고리 선택.
4. GPT Image 2용 배경 프롬프트 생성.
5. 금지어/금지 비주얼 체크.
6. 생성 후 vision QA: 텍스트 라벨, 과한 DNA, 병원 이미지, 가짜 UI, 저가 뷰티 광고 느낌 검출.

### Prompt skeleton

```text
Create a 4:5 portrait full-bleed background for a premium bio-cosmetic Instagram card news series.
Visual category: {bio-lab still life | skin-structure documentary | molecular softness | clinical calm surface}.
Brand mood: professional, calm, premium, bio-scientific, not cold, not medical.
Palette: deep violet, navy, silver, white, subtle warm skin-toned highlights.
Composition: low contrast center safe area for Korean typography overlay, detailed edges, no empty flat blocks.
Materials: frosted glass, transparent serum, brushed metal, soft lab reflection, microscopic particles.
Lighting: diffused cool white laboratory light, soft highlights, restrained cinematic depth.
Absolutely NO text, NO labels, NO letters, NO numbers, NO fake UI, NO logo, NO syringe, NO blood, NO hospital, NO doctor, NO cyberpunk neon DNA, NO generic beauty ad cliché.
```

## 추천 MCP / 도구

1. **Figma MCP**
   - 목적: 카드뉴스 레이아웃·토큰·컴포넌트 구조를 AI가 픽셀 추측하지 않고 읽게 함.
   - 용도: 디자인 시스템, 텍스트 박스, 안전영역, 팔레트, 카드 컴포넌트 전달.

2. **Playwright MCP / screenshot MCP**
   - 목적: Remotion/웹 카드뉴스를 실제 렌더링 후 스크린샷으로 검증.
   - 용도: 텍스트 겹침, 한글 줄바꿈, 대비, 안전영역, 카드별 일관성 자동 QA.

3. **Obsidian MCP 또는 vault 검색 스킬**
   - 목적: BIOFOX 캐논, 컴플라이언스, 톤앤매너, 피부과학 위키를 카드 생성 전 검색.
   - 용도: 텍스트 RAG와 시각 RAG를 분리하되 같은 브랜드 기준으로 검수.

4. **Image QA pipeline**
   - CLIP score / aesthetic predictor / vision model을 조합해 “프롬프트 적합도 + 저가 AI 느낌”을 점수화.
   - 단, 최종 판단은 자동점수보다 룰 기반 체크리스트가 더 중요.

## 추천 오픈소스 / 라이브러리

### 렌더링·카드뉴스
- Remotion: 카드뉴스/숏폼/이미지 시퀀스 렌더링의 중심. 텍스트는 코드로 고정.
- Satori + Resvg: OG 이미지처럼 정적 카드 PNG 생성에 좋음.
- html-to-image / Playwright screenshot: HTML 카드 → PNG 배치 추출.

### 디자인 시스템
- Tailwind CSS + CSS variables: 톤별 팔레트와 spacing token 고정.
- Radix UI / shadcn/ui: 관리자 UI용. 실제 카드 시각에는 과용 금지.
- Bento DS / Astryx / Chroma React: 디자인 시스템 구조 참고용. 그대로 쓰기보다 token 설계 참고.

### 과학·바이오 비주얼
- Three.js / React Three Fiber / Drei: 세포층, 입자, 단백질 폴딩 느낌의 3D 배경 제작.
- Mol* 또는 NGL Viewer: 실제 PDB 기반 분자 구조 참고/렌더링. 카드뉴스에는 직접 노출보다 추상화 추천.
- Cytoscape.js: 성장인자-수용체-피부 반응 같은 네트워크 도식.
- D3 / ECharts / Reaviz: 수치·단계·비교 도식. 과학 설명형 카드에 적합.

### 이미지 검수
- clip-score: 이미지와 프롬프트 적합도 대략 점검.
- improved-aesthetic-predictor: 미감 점수 참고용.
- sharp / jimp / canvas: 대비, 색상 분포, 여백, 텍스트 안전영역 검사.

## 고도화: 평가·색상·레퍼런스 MCP 레이어

### Awesome Evaluation of Visual Generation 적용

`ziqihuangg/Awesome-Evaluation-of-Visual-Generation`은 이미지 생성 평가 메트릭/벤치마크 큐레이션이다. BIOFOX 카드뉴스에 그대로 FID 같은 학술 메트릭을 적용하는 것은 과하다. 대신 다음처럼 **실무 QA 레이어**로 축소 적용한다.

1. **Prompt alignment**
   - CLIP Score / CLIP-FID / CMMD 계열 아이디어를 사용.
   - 생성 배경이 `premium bio-cosmetic`, `clinical calm`, `molecular softness`, `no text` 같은 기준과 맞는지 평가.

2. **Reference consistency**
   - DINO similarity / DreamSim / LPIPS 계열 아이디어를 사용.
   - Pinterest·Figma·내부 레퍼런스와 너무 멀어졌는지, 혹은 너무 복제에 가까운지 체크.

3. **Diversity without drift**
   - Vendi Score / precision-recall 계열 아이디어를 참고.
   - 8장 세트가 서로 너무 똑같지도, 완전히 다른 브랜드처럼 보이지도 않게 점검.

4. **Trustworthiness / safety**
   - 이미지 안의 텍스트 라벨, 의료 장면, 주사기, 병원, 혈액, 과장된 before/after 암시, 사이버펑크 DNA 클리셰를 vision QA로 검출.

실무 구현은 `academic metric full stack`이 아니라 다음 4점 척도면 충분하다.

```json
{
  "biofox_fit": 0-5,
  "text_overlay_safety": 0-5,
  "anti_slop_score": 0-5,
  "reference_similarity": 0-5,
  "fail_reasons": []
}
```

### Material Color Utilities 적용

`material-foundation/material-color-utilities`는 Material You의 색상 알고리즘 라이브러리다. BIOFOX에는 특히 다음 기능이 유용하다.

- HCT 색공간: hue/chroma/tone 기반이라 사람이 느끼는 밝기·채도 조절이 안정적.
- Tonal palette: 딥퍼플 하나에서 0~100 tone 팔레트를 뽑아 카드 배경/텍스트/보조색을 자동 생성.
- Contrast: 카드뉴스 한글 텍스트 대비 자동 보정.
- Quantize/Score: Pinterest·광고 레퍼런스 이미지에서 대표색 추출 후 BIOFOX 팔레트에 맞는 색만 선택.
- Dislike fix: 탁하거나 불쾌하게 느껴지는 색 자동 보정.
- Temperature: 딥퍼플 기준 보색/유사색을 만들되, 과한 초록·형광색으로 튀는 것을 제한.

BIOFOX 팔레트 엔진은 이렇게 설계한다.

```ts
const BIOFOX_SEEDS = {
  info: '#E8DFD4',
  bridge: '#3F6A57',
  conversion: '#5B3A8E',
  scienceDark: '#172033',
  silver: '#C7CBD1'
};
```

생성 플로우:
1. 카드 톤 결정(info/bridge/conversion)
2. seed color 선택
3. Material Color Utilities로 tonal palette 생성
4. background / foreground / accent / muted / border token 생성
5. contrast ratio 기준 미달 시 tone 자동 보정
6. GPT Image 2 프롬프트에도 hex를 넣고, Remotion CSS token에도 같은 값을 사용

핵심은 **이미지 프롬프트 색상과 코드 타이포 색상을 같은 팔레트 엔진에서 뽑는 것**이다. 그래야 배경과 텍스트가 따로 놀지 않는다.

### Pinterest MCP 적용

Pinterest MCP는 레퍼런스 수집/보드 관리에 적합하다. 단, 그대로 이미지를 베끼면 안 되고 “구조 추출” 용도로 써야 한다.

권장 보드 구조:
- `BIOFOX / Bio Lab Premium`
- `BIOFOX / Molecular Softness`
- `BIOFOX / Clinical Calm Surface`
- `BIOFOX / Skin Structure Documentary`
- `BIOFOX / Anti Slop - Avoid`

수집 플로우:
1. Pinterest MCP로 보드/핀 목록 수집.
2. 각 핀 이미지를 vision으로 분석.
3. 색상, 조명, 재질, 밀도, 구도, 금지 요소를 JSON으로 추출.
4. 원본 이미지는 그대로 프롬프트에 쓰지 않고 `reference descriptor`만 저장.
5. GPT Image 2 프롬프트는 descriptor 기반으로 생성.

Pinterest 레퍼런스 descriptor 예시:

```json
{
  "source": "pinterest",
  "board": "BIOFOX / Bio Lab Premium",
  "visual_role": "material_reference",
  "palette": ["deep violet", "silver", "cool white"],
  "materials": ["frosted glass", "brushed metal", "transparent serum"],
  "composition": "macro still life, low center density",
  "avoid": ["logo", "text", "medical device", "needle"]
}
```

### Meta Ads MCP 적용

Meta Ads MCP는 디자인 레퍼런스보다 **성과 레퍼런스**에 가깝다. 어떤 크리에이티브가 실제로 CTR, 저장, DM, 예약 전환에 강했는지 가져오는 용도다.

적용 방식:
1. Meta Ads MCP로 과거 캠페인/광고/크리에이티브/인사이트 조회.
2. 상위 성과 소재의 썸네일·카피·CTA·색감·구도를 분석.
3. “예쁜 디자인”이 아니라 “성과가 있던 구조”를 카드뉴스 템플릿에 반영.
4. 광고 계정 write 작업은 금지/확인제. 기본은 read-only 분석 MCP로 사용.

추천 추출 필드:
- campaign objective
- creative thumbnail
- primary text
- headline
- CTA type
- CTR / CPC / CPM / frequency
- saves / comments / DMs가 있으면 우선
- audience age/gender/placement

성과 레퍼런스 descriptor 예시:

```json
{
  "source": "meta_ads",
  "creative_id": "...",
  "objective": "engagement",
  "winning_pattern": "large plain Korean hook + muted clinical background + comment CTA",
  "palette": ["warm beige", "dark brown", "soft green accent"],
  "layout": "headline top 35%, checklist middle, CTA bottom",
  "performance_note": "high save rate, low CPC",
  "reuse_as": "structure_only"
}
```

### 통합 아키텍처

```text
Pinterest MCP          Meta Ads MCP
    ↓                       ↓
Visual references       Performance references
    ↓                       ↓
Vision descriptor      Creative-performance descriptor
    ↓                       ↓
Reference Library / Vector DB / JSON store
    ↓
BIOFOX Visual Director Skill
    ↓
Material Color Utilities palette engine
    ↓
GPT Image 2 background generation
    ↓
Remotion typography/layout render
    ↓
Visual Generation Evaluation QA
    ↓
Pass → reference library에 저장 / Fail → anti-slop pattern에 저장
```

## 최종 판단

BIOFOX 카드뉴스는 “예쁜 AI 이미지”를 목표로 하면 망한다. 목표는 **원장님이 자기 인스타에 올려도 광고처럼 안 보이고, 소비자는 저장하고 싶고, 브랜드는 EGF/FGF 세계관을 잃지 않는 카드 세트**다.

따라서 시스템은 이렇게 가야 한다.

1. 위키 RAG로 내용 생성.
2. 톤별 카드 구조 결정.
3. 비주얼 카테고리와 팔레트 선택.
4. GPT Image 2는 텍스트 없는 풀블리드 배경만 생성.
5. Remotion/HTML이 타이포·레이아웃을 담당.
6. Playwright/vision QA로 AI slop 체크.
7. 좋은 세트는 레퍼런스 라이브러리에 저장하고, 실패 세트는 금지 패턴으로 축적.

## Connections
- [[BIOFOX 톤앤매너는 전문적이되 쉽고 따뜻한 권유형이다]] — 시각 톤의 직접 근거.
- [[BIOFOX 브랜드 캐논 - 절대 변하지 않는 핵심 원칙들]] — 브랜드 구조와 컴플라이언스 우선순위.
- [[BIOFOX 과학 다큐 영상 서사 설계 — 성장인자 직접재생 다이브]] — 분자·세포·피부구조 다큐 톤을 카드뉴스로 축소 적용.
- [[BIOFOX 기술설명회 덱을 외부 B2B 자료로 전환할 때의 컴플라이언스 게이트와 요구사항]] — 내부 기술 자산 외부화 시 표현 수위 조절.

## References
- Hermes skill: `hbiofox`
- Hermes skill: `gpt-image-generate`
- Web references searched 2026-07-12: Figma MCP, Playwright MCP, screenshot MCP, Reaviz, Bento DS, Astryx, Chroma React, BioVIS, MolViewer, clip-score, improved-aesthetic-predictor
