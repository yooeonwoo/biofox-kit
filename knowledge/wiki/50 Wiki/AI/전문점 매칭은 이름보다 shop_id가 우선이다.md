---
title: "전문점 매칭은 이름보다 shop_id가 우선이다"
type: zettel
status: seed
tags: [AI, 바이오폭스, 방법론]
aliases: []
created: 2026-08-14
updated: 2026-08-14
---

# 전문점 매칭은 이름보다 shop_id가 우선이다

## Main Idea
전문점명만 맞추면 오타와 동명이인에서 깨진다. 숨김 컬럼 shop_id, supervisor_id로 매칭하고 이름은 검증용이다.

## Context
매출 업로드 스키마 규칙.

## Connections
- [[매출 업로드는 WARNING이 있으면 저장하지 않는다]] — id 불일치가 경고가 된다

## References
- ChatGPT보내기 · 안전한 코덱스 프롬프트
