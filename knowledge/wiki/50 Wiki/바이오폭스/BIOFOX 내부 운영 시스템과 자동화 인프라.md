---
title: "BIOFOX 내부 운영 시스템과 자동화 인프라"
type: zettel
status: seed
tags: [바이오폭스, 운영, 자동화, CRM]
aliases: []
created: 2026-05-10
updated: 2026-05-10
---

# BIOFOX 내부 운영 시스템과 자동화 인프라

## Main Idea
운영통합관리시스템: 업무센터, 생산센터, 교육센터, 메신저, 알림, PWA.

생산센터: 발주관리, 부자재 입고/재고, 완제품 생산입고, 제품별·부자재 생산현황, AI 발주 등록.

교육센터: 교육일정, 신청관리(구글폼→구글시트), 입금관리, 메시지관리, 예외관리(미참여, 환불).

CRM: Monday CRM 유사 프로그램 자체 개발 목표. AI 주도, 컴포넌트 세분화.

기술 스택: Supabase(DB/Storage), Notion(보고서), Meta Pixel+GTM+GA+sGTM+CAPI(추적), PWA(모바일+푸시알림).

도구: Claude, Claude Code, ChatGPT, Manus, Codex, OpenClaw, Hermes, n8n 등.

허위소문 대응: 임상사진 무보정 공개, 포토샵 조작/허위 제보 현금 100만원 보상.

BIOFOX Smart AI: Play Store 앱 게시.

## Context
운영 시스템까지 직접 만드는 것이 BIOFOX가 플랫폼인 이유다.

## Connections
- [[BIOFOX는 제품회사가 아니라 프로페셔널 플랫폼이다]] — 운영 시스템이 플랫폼의 백본
- [[BIOFOX 콘텐츠는 소재 축적-재기획-재활용 체계로 80% AI 자동화를 목표한다]] — 콘텐츠 자동화도 이 인프라 위에

## References
- BIOFOX-GPT-지식추출-2026-05-10
