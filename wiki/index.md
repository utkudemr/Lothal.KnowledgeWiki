# Knowledge Wiki Index

This is the main navigation page for the knowledge wiki.

## Getting Started

- [Knowledge Wiki Ana Sayfa](home.md) - Konuya ve okuma amacına göre rota seçmek için ana okuma paneli.
- [Reading Guide](reading-guide.md) - Learn how to effectively read and use generated wiki outputs.

## Reading Paths

- [Agentic Development](reading-paths/agentic-development.md) - Agent workflow, judgment, orchestration ve flow efficiency rotası.
- [Backend System Design](reading-paths/backend-system-design.md) - Veri otoritesi, cache ve dağıtık veri kararları üzerinden system design rotası.
- [Caching and Consistency](reading-paths/caching-and-consistency.md) - Cache, source of truth, invalidation ve tutarlılık rotası.
- [Local-first and Offline](reading-paths/local-first-and-offline.md) - Offline-first, local-first, sync ve CRDT rotası.
- [Interview Prep](reading-paths/interview-prep.md) - Mülakat notlarını konu kümeleri ve destekleyici sentezlerle çalışma rotası.

## Core Concepts

- [LLM Wiki](concepts/llm-wiki.md) - LLM tarafindan bakimi yapilan kalici markdown bilgi katmani.
- [RAG](concepts/rag.md) - Sorgu aninda ilgili dokuman parcalarini getirerek cevap uretme yaklasimi.
- [Agent Workflow](concepts/agent-workflow.md) - Ajanin kaynak ingest, query, lint ve wiki bakimini kuralli sekilde yapmasi.
- [Agent Orchestration](concepts/agent-orchestration.md) - Ana agent'ın delegasyon, context paylaşımı, kısmi sonuçları birleştirme ve sonraki adım kararlarını yönetmesi.
- [Agent Instructions](concepts/agent-instructions.md) - Repository icinde ajanlara proje kurallarini, kalite kapilarini ve maintainer beklentilerini anlatan talimat katmani.
- [Local-first Software](concepts/local-first-software.md) - Yerel cihazdaki veriyi birincil kabul eden, cloud'u destekleyici sync/backup katmani olarak kullanan mimari yaklasim.
- [CRDT](concepts/crdt.md) - Es zamanli dagitik degisiklikleri deterministik merge edebilen veri yapisi ailesi.
- [Cache Karar Kriterleri](concepts/cache-karar-kriterleri.md) - Cache kullanma kararini frekans, maliyet, stabilite, guvenlik ve olceklenebilirlik acisindan degerlendirme yaklasimi.
- [AI Caginda Judgment](concepts/ai-caginda-judgment.md) - LLM ve agent ciktilarini varsayim, risk, baglam ve dogruluk acisindan degerlendirme becerisi.
- [Two-Track Agentic Development](concepts/two-track-agentic-development.md) - Spec ve implementation hatlarini ayirarak agent workflow'unda bottleneck ve insan dikkatini yonetme yaklasimi.

## Syntheses

- [RAG vs LLM Wiki](syntheses/rag-vs-llm-wiki.md) - Query-time retrieval ile ingest-time kalici sentez arasindaki farklar.
- [Coding Agent vs Knowledge Wiki Agent](syntheses/coding-agent-vs-knowledge-wiki-agent.md) - Kod degistiren ajanlarla bilgi wiki'si ureten ajanlarin farkli riskleri ve kalite kapilari.
- [Cloud-first vs Offline-first vs Local-first](syntheses/cloud-first-vs-offline-first-vs-local-first.md) - Server-authoritative, offline-capable ve local-authoritative mimari yaklasimlarin pratik farklari.
- [Cache vs Source of Truth](syntheses/cache-vs-source-of-truth.md) - Cache'in gecici performans kopyasi, source of truth'un ise yetkili domain kaydi olmasi arasindaki fark.
- [Prompt Playbook vs Kalibre Judgment](syntheses/prompt-playbook-vs-kalibre-judgment.md) - Hazir prompt kaliplari ile AI ciktisini kalibre ederek degerlendirme arasindaki fark.
- [Parallel Agent vs Flow Efficiency](syntheses/parallel-agent-vs-flow-efficiency.md) - Cok agent calistirma fikri ile bottleneck ve flow verimliligi odakli agent workflow'u arasindaki fark.
- [Single Agent vs Agent Orchestration](syntheses/single-agent-vs-agent-orchestration.md) - Tek agent sadeliği ile subagent paralelliği ve koordinasyon maliyeti arasındaki seçim.

## Interview Notes

- [Offline-first ile local-first arasindaki fark nedir?](interview/offline-first-ile-local-first-arasindaki-fark-nedir.md) - Offline mimari, local data ownership ve sync tradeoff'larini anlatan mulakat cevabi.
- [Cache ne zaman kullanilmali?](interview/cache-ne-zaman-kullanilmali.md) - Cache kararini system design mulakatinda TTL, invalidation, guvenlik ve stale data tradeoff'lariyla savunma cevabi.
- [AI ciktilarini nasil degerlendirirsin?](interview/ai-ciktilarini-nasil-degerlendirirsin.md) - LLM ciktisini varsayim, domain bilgisi, test, review ve validation ile kontrol etmeyi anlatan mulakat cevabi.
- [Agentic development'ta neden cok agent her zaman verimli degildir?](interview/agentic-developmentta-neden-cok-agent-her-zaman-verimli-degildir.md) - Agent sayisi, spec bottleneck'i, review ve verification kapasitesi hakkinda mulakat cevabi.
- [Agent orchestration nedir ve ne zaman kullanılmalıdır?](interview/agent-orchestration-nedir-ve-ne-zaman-kullanilmalidir.md) - Delegasyon, context, aggregation ve orchestration maliyetlerini açıklayan mülakat cevabı.

## Projects

- [Lothal KnowledgeWiki](projects/lothal-knowledgewiki.md) - Bu repository'nin LLM Wiki deseniyle nasil kullanilacagina dair proje notu.
- [Automation Roadmap](projects/automation-roadmap.md) - Ingest, review ve validation workflow'undaki manuel adimlari azaltma yol haritasi.
- [Phase 2 Status Report](projects/phase-2-status-report.md) - Deterministik wiki validation, prompt gate'leri ve GitHub Actions durum raporu.
- [Phase 1 Status Report](projects/phase-1-status-report.md) - Faz 1 sonunda mimari, workflow, tamamlanan isler ve sonraki adimlar.

## Companies / Job Notes

_No company notes yet._

## People

_No people notes yet._
