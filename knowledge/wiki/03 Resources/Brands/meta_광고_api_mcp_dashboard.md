# Meta 광고 API·MCP·대시보드 — BIOFOX 실전 가이드

> 최종 업데이트: 2026-04-12
> 목적: Meta 광고를 API/MCP/ETL로 자동 관리·시각화하는 방법 정리

---

## 1. 현재 사용 가능한 소스

### 1-1. Meta Marketing API (유일한 공식 API)
- Base URL: https://graph.facebook.com/v21.0/
- 인증: System User 토큰 (만료 없음) 추천
- 권한: ads_read (조회) / ads_management (관리)
- Python SDK: pip install facebook_business
- Node SDK: npm install facebook-nodejs-business-sdk
- Rate Limit: ad account당 ~200콜/시간

### 1-2. MCP 서버
- **mcp-server-meta-ads** (XiangLu) ← 메인 추천
  - npx -y mcp-server-meta-ads
  - 풀 CRUD 20개+ 도구, 별 172개
  - 환경변수: META_ACCESS_TOKEN
- **meta-ads-mcp-server** (pablomuro) ← 브레이크다운 필요 시 추가
  - npx -y meta-ads-mcp-server
  - 조회 전용, 연령/성별/국가 브레이크다운 지원

---

## 2. 대시보드 구축 방법 (ETL + BI)

### 아키텍처
```
Meta Marketing API
      ↓
Airbyte (Docker) — 15분~1시간 자동 싱크
      ↓
PostgreSQL — 15개+ 테이블 자동 생성
      ↓
dbt (fivetran/dbt_facebook_ads) — raw → 분석 모델
      ↓
Metabase (Docker) — 웹 대시보드
```

### ETL 도구 비교
| 도구 | 특징 | 설치 |
|------|------|------|
| Airbyte | 가장 추천. 15개+ 스트림 | Docker |
| Meltano | CLI, 가벼움 | pip |
| dlt | 파이썬 몇 줄 | pip |

### Airbyte 주요 스트림
- campaigns, ad_sets, ads, ad_creatives
- ad_insights (일별 통합)
- ad_insights_age_and_gender, _country, _platform_and_device
- 커스텀 인사이트 직접 정의 가능
- Lookback Window 28일 (소급 변경 대응)

### DB
- PostgreSQL — 기본 선택 (1억 행 이하 충분)
- ClickHouse — 대규모 시 업그레이드 (집계 10~100x 빠름)

### BI 도구
- Metabase — 노코드, Docker 한 줄, 대부분에 적합
- Apache Superset — 파워유저, 30+ 차트

---

## 3. 3가지 접근법 정리

| 접근법 | 언제 | 개발량 |
|--------|------|--------|
| MCP → Hermes 연결 | 일상 조회/관리 | 5분 |
| API 직접 (Python SDK) | 커스텀 자동화 | 수일 |
| ETL + BI | 시각화 대시보드 | 1~2주 |

→ 세 가지 섞어 쓰는 게 최적.

---

## 4. 셋업 체크리스트

- [ ] Meta Business Manager 계정
- [ ] developers.facebook.com 앱 생성 (Business 타입)
- [ ] Marketing API 제품 추가
- [ ] System User 생성 → 광고계정 권한 부여 → 토큰 발급
- [ ] Ad Account ID 확인 (act_XXXXXXXXX)

---

## 5. 참고 GitHub 레포

- josephmachado/elt_pipeline_airbyte_dbt_superset — Docker Compose 풀스택
- openmartech/marketing-analytics-stack — Airbyte+dbt+PG+Metabase
- fivetran/dbt_facebook_ads — dbt 변환 모델
- XiangLuworworworworworwor/mcp-server-meta-ads — MCP 서버

---

## 6. 주의사항

- Meta 인사이트 데이터는 28일간 소급 변경됨 (어트리뷰션)
- 당일 ROAS는 잠정치. 확정까지 최대 28일.
- Rate Limit 초과 시 429 에러. 캐시/ETL로 흡수 필수.
- API 버전 2년마다 deprecation. 현재 v21.0.
