# Lothal KnowledgeWiki

## Purpose

Lothal KnowledgeWiki, .NET backend gelistirici icin teknik kaynaklari kalici, baglantili ve tekrar kullanilabilir markdown bilgi tabanina donusturen bir agent-assisted knowledge management reposudur.

Amac, makaleleri, tweet'leri, repo notlarini, video ozetlerini, is ilanlarini ve interview sorularini sadece arsivlemek degil; bunlardan pratik konsept sayfalari, sentezler, interview cevaplari ve proje notlari uretmektir.

## Current State

Repo, LLM Wiki desenini uygulayan basit ama genisleyebilir bir yapiya sahip:

- `raw/` altinda immutable kaynaklar tutulur.
- `wiki/` altinda islenmis bilgi sayfalari tutulur.
- `AGENTS.md`, ajanin nasil davranacagini ve hangi formatlari kullanacagini belirler.
- `wiki/index.md`, insan ve ajan icin navigasyon saglar.
- `wiki/log.md`, ingest ve buyuk guncellemeleri kronolojik olarak kaydeder.
- Ingest, review ve validation adimlari iki-track agentic workflow'a benzer sekilde ayrik dikkat turleri olarak ele alinir.

## Important Concepts

- [LLM Wiki](../concepts/llm-wiki.md)
- [RAG](../concepts/rag.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Harness](../concepts/agent-harness.md)
- [Agent Orchestration](../concepts/agent-orchestration.md)
- [Agent Instructions](../concepts/agent-instructions.md)
- [AI Caginda Judgment](../concepts/ai-caginda-judgment.md)
- [Two-Track Agentic Development](../concepts/two-track-agentic-development.md)
- [Local-first Software](../concepts/local-first-software.md)
- [CRDT](../concepts/crdt.md)
- [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
- [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md)
- [Prompt Playbook vs Kalibre Judgment](../syntheses/prompt-playbook-vs-kalibre-judgment.md)
- [Parallel Agent vs Flow Efficiency](../syntheses/parallel-agent-vs-flow-efficiency.md)
- [Single Agent vs Agent Orchestration](../syntheses/single-agent-vs-agent-orchestration.md)
- [Classic Agent vs Agent Harness](../syntheses/classic-agent-vs-agent-harness.md)
- [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md)

## Architecture Notes

Bu repo, ham kaynak ile islenmis bilgi arasinda net bir ayrim kurar. `raw/` source of truth olarak kalir; LLM bu katmani degistirmez. `wiki/` ise kaynaklardan turetilen, linklenen ve zaman icinde guncellenen bilgi katmanidir.

Bu ayrim backend mimarisindeki event log ve read model ayrimina benzer. Ham kaynaklar audit edilebilir girdi, wiki sayfalari ise sorgulanabilir ve insan tarafindan tuketilebilir projeksiyondur.

Local-first software kaynagi bu proje icin ek bir lens sunar: `raw/` ve `wiki/` birlikte, cloud service'e bagli olmayan, git ile tasinabilir ve lokal olarak okunabilir bir bilgi sistemi olusturur. Bu repo tam anlamiyla collaborative CRDT uygulamasi degildir; fakat veri sahipligi, uzun omurluluk, offline okunabilirlik ve export edilebilir markdown formatlari acisindan local-first degerleriyle uyumludur.

## Agent Workflow Notes

Ingest akisi su sekilde islemelidir:

- Ajan once `AGENTS.md` dosyasini okur.
- Ilgili raw kaynak incelenir.
- Mevcut wiki sayfalari kontrol edilerek duplicate sayfa olusturulmaktan kacinilir.
- Gerekli konsept, synthesis, interview, project veya company sayfalari olusturulur ya da guncellenir.
- Sayfalar arasinda relative markdown linkleri kurulur.
- Kaynak referansi her sayfada korunur.
- `wiki/index.md` guncellenir.
- `wiki/log.md` dosyasina append-only kayit eklenir.

Aspire `AGENTS.md` ornegi, bu repoda talimatlarin daha da operasyonel hale getirilebilecegini gosterir. Sadece "Turkce yaz" veya "raw'a dokunma" gibi genel kurallar degil, hangi prompt'un ne zaman kullanilacagi, review'un hangi kalite kapilarini kontrol edecegi, source reference eksikliginin nasil ele alinacagi ve index/log tutarsizliklarinin nasil yakalanacagi da acik yazilabilir.

AI judgment kaynagi bu workflow'un neden sadece prompt template'lerinden ibaret olmamasi gerektigini netlestirir. Ingest prompt'u baslatma aracidir; asil kalite, agent ciktisinin kaynakla, mevcut wiki graph'iyle, insan review'uyla ve `validate-wiki.ps1` gibi deterministik kontrollerle kalibre edilmesinden gelir.

Two-track agentic development kaynagi bu projeye ek bir workflow prensibi getirir: daha cok agent calistirmak yerine bottleneck'i netlestirmek gerekir. Lothal.KnowledgeWiki'de source context ve raw content spec input gibi davranir; ingest bilgi uretimi, review ve validation ise verification hattidir.

Agent orchestration bu projede varsayılan değil, görev yapısı gerektirdiğinde kullanılan kontrollü bir optimizasyon olmalıdır. Büyük bir ingest sırasında duplicate taraması, teknik iddia analizi ve interview extraction gibi bağımsız okuma görevleri subagent'lara verilebilir. Ana agent sayfa planını, ortak terminolojiyi, source reference'ları ve final dosya değişikliklerini sahiplenmelidir. Aynı wiki dosyasını birden fazla agent'ın paralel düzenlemesi yerine kısmi sonuçlar ana agent'ta birleştirilmelidir; `validate-wiki.ps1` ise agent görüşünden bağımsız deterministik kalite kapısı olarak kalmalıdır.

Agent harness bakışı bu repository'deki parçaların rolünü netleştirir: `AGENTS.md` policy ve çalışma sözleşmesi, helper scriptler kontrollü tool yüzeyi, Git kalıcı çalışma alanı ve audit izi, `validate-wiki.ps1` ise deterministik kabul kapısıdır. Repo henüz durable run state, otomatik recovery veya risk-temelli approval sunan tam bir harness değildir; bu ayrım gelecekteki otomasyonu gereğinden fazla otonomlaştırmadan tasarlamak için korunmalıdır.

## Next Ideas

- Periyodik lint akisi tanimlamak: orphan sayfalar, eksik source reference, stale index entry ve eksik related page kontrolleri.
- Minimal harness sinirini belgelemek: run state, izin verilen araclar, validation sonucu, approval gerektiren eylemler ve audit artefact'lari.
- Query sonucunda uretilen degerli cevaplarin hangi kosullarda wiki sayfasina donusecegini netlestirmek.
- Belirli sayfa sayisindan sonra markdown aramasi, BM25 veya qmd benzeri lokal arama araclarini degerlendirmek.
- Interview hazirligi icin konsept sayfalarindan cevap odakli interview sayfalari uretmek.
- `AGENTS.md` icinde review prompt'unun hangi durumlarda calistirilacagini ve hangi kalite kontrollerinin zorunlu oldugunu daha net yazmak.
- AI judgment icin kisa bir review checklist'i denemek: varsayimlar, source reference, duplicate riski, uygulanabilirlik ve validation sonucu.
- Ingest workflow icin spec/implementation/verification ayrimini daha gorunur hale getirmek: raw context, ingest output, review result ve validation output'u ayrik artefaktlar olarak dusunmek.
- Büyük ingest'ler için subagent sonuç sözleşmesini denemek: kapsam, bulgu, kanıt, belirsizlik, önerilen sayfa ve açık sorular.
- Aspire'daki pattern-based instruction fikrini bu repo icin sade bir sekilde uyarlamak: `raw/`, `wiki/concepts/`, `wiki/syntheses/`, `wiki/interview/` ve `wiki/projects/` icin ayrik beklentiler.
- Local-first bakisiyla wiki'nin tamamen offline okunabilir, export edilebilir ve baska araclarla islenebilir kalmasini kalite hedefi yapmak.
- Ileride cok kullanicili wiki duzenleme ihtiyaci dogarsa CRDT veya Git tabanli merge stratejilerini ayri bir sentezde degerlendirmek.

## Related Pages

- [LLM Wiki](../concepts/llm-wiki.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Harness](../concepts/agent-harness.md)
- [Agent Orchestration](../concepts/agent-orchestration.md)
- [Agent Instructions](../concepts/agent-instructions.md)
- [AI Caginda Judgment](../concepts/ai-caginda-judgment.md)
- [Two-Track Agentic Development](../concepts/two-track-agentic-development.md)
- [Local-first Software](../concepts/local-first-software.md)
- [CRDT](../concepts/crdt.md)
- [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
- [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md)
- [Prompt Playbook vs Kalibre Judgment](../syntheses/prompt-playbook-vs-kalibre-judgment.md)
- [Parallel Agent vs Flow Efficiency](../syntheses/parallel-agent-vs-flow-efficiency.md)
- [Single Agent vs Agent Orchestration](../syntheses/single-agent-vs-agent-orchestration.md)
- [Classic Agent vs Agent Harness](../syntheses/classic-agent-vs-agent-harness.md)
- [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md)

## Source References

- `raw/articles/karpathy-llm-wiki.md`
- `raw/repos/aspire-agents-md.md`
- `raw/articles/2026-06-20-local-first-software.md`
- `raw/articles/2026-06-23-the-most-important-skill-in-the-age-of-ai-judgment.md`
- `raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`
- `raw/tweets/2026-06-27-agent-orchestration-explained.md`
- `raw/tweets/2026-06-28-agent-harness-vs-classic-agent.md`
