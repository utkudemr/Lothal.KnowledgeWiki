# Knowledge Wiki Index

This is the main navigation page for the knowledge wiki.

## Getting Started

- [Reading Guide](reading-guide.md) - Learn how to effectively read and use generated wiki outputs.

## Core Concepts

- [LLM Wiki](concepts/llm-wiki.md) - LLM tarafindan bakimi yapilan kalici markdown bilgi katmani.
- [RAG](concepts/rag.md) - Sorgu aninda ilgili dokuman parcalarini getirerek cevap uretme yaklasimi.
- [Agent Workflow](concepts/agent-workflow.md) - Ajanin kaynak ingest, query, lint ve wiki bakimini kuralli sekilde yapmasi.
- [Agent Instructions](concepts/agent-instructions.md) - Repository icinde ajanlara proje kurallarini, kalite kapilarini ve maintainer beklentilerini anlatan talimat katmani.
- [Local-first Software](concepts/local-first-software.md) - Yerel cihazdaki veriyi birincil kabul eden, cloud'u destekleyici sync/backup katmani olarak kullanan mimari yaklasim.
- [CRDT](concepts/crdt.md) - Es zamanli dagitik degisiklikleri deterministik merge edebilen veri yapisi ailesi.
- [Cache Karar Kriterleri](concepts/cache-karar-kriterleri.md) - Cache kullanma kararini frekans, maliyet, stabilite, guvenlik ve olceklenebilirlik acisindan degerlendirme yaklasimi.

## Syntheses

- [RAG vs LLM Wiki](syntheses/rag-vs-llm-wiki.md) - Query-time retrieval ile ingest-time kalici sentez arasindaki farklar.
- [Coding Agent vs Knowledge Wiki Agent](syntheses/coding-agent-vs-knowledge-wiki-agent.md) - Kod degistiren ajanlarla bilgi wiki'si ureten ajanlarin farkli riskleri ve kalite kapilari.
- [Cloud-first vs Offline-first vs Local-first](syntheses/cloud-first-vs-offline-first-vs-local-first.md) - Server-authoritative, offline-capable ve local-authoritative mimari yaklasimlarin pratik farklari.
- [Cache vs Source of Truth](syntheses/cache-vs-source-of-truth.md) - Cache'in gecici performans kopyasi, source of truth'un ise yetkili domain kaydi olmasi arasindaki fark.

## Interview Notes

- [Offline-first ile local-first arasindaki fark nedir?](interview/offline-first-ile-local-first-arasindaki-fark-nedir.md) - Offline mimari, local data ownership ve sync tradeoff'larini anlatan mulakat cevabi.
- [Cache ne zaman kullanilmali?](interview/cache-ne-zaman-kullanilmali.md) - Cache kararini system design mulakatinda TTL, invalidation, guvenlik ve stale data tradeoff'lariyla savunma cevabi.

## Projects

- [Lothal KnowledgeWiki](projects/lothal-knowledgewiki.md) - Bu repository'nin LLM Wiki deseniyle nasil kullanilacagina dair proje notu.
- [Automation Roadmap](projects/automation-roadmap.md) - Ingest, review ve validation workflow'undaki manuel adimlari azaltma yol haritasi.
- [Phase 2 Status Report](projects/phase-2-status-report.md) - Deterministik wiki validation, prompt gate'leri ve GitHub Actions durum raporu.
- [Phase 1 Status Report](projects/phase-1-status-report.md) - Faz 1 sonunda mimari, workflow, tamamlanan isler ve sonraki adimlar.

## Companies / Job Notes

_No company notes yet._

## People

_No people notes yet._
