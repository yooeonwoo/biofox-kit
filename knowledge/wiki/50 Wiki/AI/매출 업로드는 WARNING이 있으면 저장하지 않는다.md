---
title: "매출 업로드는 WARNING이 있으면 저장하지 않는다"
type: zettel
status: seed
tags: [AI, 바이오폭스, 방법론]
aliases: []
created: 2026-08-14
updated: 2026-08-14
---

# 매출 업로드는 WARNING이 있으면 저장하지 않는다

## Main Idea
매출·커미션은 중복 가능성이 있으면 저장하지 않는 편이 안전하다. 1차는 ERROR와 WARNING이 0건일 때만 최종 저장한다.

## Context
슈퍼바이저 엑셀 업로드. 편의보다 정산 데이터가 우선이다.

## Connections
- 코덱스는 한 단계만 시키고 기존 로직을 남긴다 — 가드를 최소 수정으로 넣는다
- [[전문점 매칭은 이름보다 shop_id가 우선이다]] — WARNING의 흔한 원인

## References
- ChatGPT보내기 · 안전한 코덱스 프롬프트
