# Agentic Development Okuma Rotası

## Amaç

Agent destekli geliştirmeyi yalnızca prompt yazmak veya daha çok agent çalıştırmak olarak değil; talimat, judgment, iş akışı, delegasyon ve verification sistemi olarak anlamak.

## Kimler Okumalı?

- Coding agent'larla production kodu veya kalıcı dokümantasyon üreten geliştiriciler.
- Agent sayısını artırmadan önce darboğazı ve review kapasitesini anlamak isteyenler.
- Repository kurallarını tekrarlanabilir bir agent workflow'una dönüştürenler.

## 1. Karar Çerçevesi: Önce Sentezler

1. [Parallel Agent vs Flow Efficiency](../syntheses/parallel-agent-vs-flow-efficiency.md) — Agent sayısı yerine specification, review ve verification darboğazlarını gör.
2. [Single Agent vs Agent Orchestration](../syntheses/single-agent-vs-agent-orchestration.md) — Delegasyonun ne zaman paralellik, ne zaman koordinasyon borcu ürettiğini ayır.
3. [Prompt Playbook vs Kalibre Judgment](../syntheses/prompt-playbook-vs-kalibre-judgment.md) — İyi girdinin neden tek başına güvenilir çıktı sağlamadığını anla.
4. [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md) — Kod ve bilgi üretiminde farklı kalite kapılarını karşılaştır.

## 2. Temel Kavramlar

1. [Agent Workflow](../concepts/agent-workflow.md) — Ingest, query, bakım ve doğrulamayı tek bir operasyon modeli olarak oku.
2. [AI Çağında Judgment](../concepts/ai-caginda-judgment.md) — Model çıktısını varsayım, risk, kanıt ve domain bağlamıyla değerlendirmeyi öğren.
3. [Two-Track Agentic Development](../concepts/two-track-agentic-development.md) — Spec ve implementation hatlarının ayrılmasının akışı nasıl iyileştirdiğini gör.
4. [Agent Orchestration](../concepts/agent-orchestration.md) — Delegasyon, context sınırı ve aggregation sorumluluklarını derinleştir.
5. [Agent Instructions](../concepts/agent-instructions.md) — Repository bilgisini agent için sürümlenebilir operasyonel hafızaya dönüştür.

## 3. Mülakatla Pekiştir

1. [AI çıktılarını nasıl değerlendirirsin?](../interview/ai-ciktilarini-nasil-degerlendirirsin.md)
2. [Agentic development'ta neden çok agent her zaman verimli değildir?](../interview/agentic-developmentta-neden-cok-agent-her-zaman-verimli-degildir.md)
3. [Agent orchestration nedir ve ne zaman kullanılmalıdır?](../interview/agent-orchestration-nedir-ve-ne-zaman-kullanilmalidir.md)

## Bu Rotadan Sonra Neyi Anlamalısın?

- Agent throughput'unun yalnızca model veya agent sayısıyla belirlenmediğini.
- Prompt kalitesi ile human judgment ve deterministic validation arasındaki farkı.
- Tek agent, paralel agent ve orchestration seçeneklerinin trade-off'larını.
- Spec, implementation, review ve verification adımlarının neden ayrı kapasite sınırları olduğunu.
- `AGENTS.md`, testler ve validator'ların agent davranışını nasıl güvenli hale getirdiğini.

## Sonraki Okuma Rotaları

- [Backend System Design](backend-system-design.md) — Agent'larla verilen mimari kararları backend trade-off'ları üzerinde uygula.
- [Interview Prep](interview-prep.md) — Agentic development cevaplarını diğer teknik konu kümeleriyle birlikte tekrar et.

## Source References

Bu rota, bağlantı verdiği mevcut wiki sayfalarının kaynak referanslarını miras alan bir navigasyon sayfasıdır.
