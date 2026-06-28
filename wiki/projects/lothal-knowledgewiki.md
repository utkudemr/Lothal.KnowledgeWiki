# Lothal KnowledgeWiki

## Purpose

Lothal KnowledgeWiki, .NET backend geliştirici için kişisel teknik asistan akışının public engine/framework reposudur. Teknik kaynakları kalıcı, bağlantılı ve tekrar kullanılabilir markdown bilgi yapılarına dönüştüren scriptleri, promptları, validation kurallarını, reading path yapısını ve public-safe örnekleri geliştirir.

Amaç, makaleleri, tweet'leri, repo notlarını, video özetlerini, iş ilanlarını ve interview sorularını yalnızca arşivlemek değil; bunlardan pratik konsept sayfaları, sentezler, interview cevapları ve proje notları üreten sistemi geliştirmektir. Kullanıcının gerçek ve özel bilgi belleği public repo dışında ayrı bir `KnowledgeMemory` klasöründe yaşayacaktır.

## Current State

Repo, LLM Wiki desenini uygulayan basit ama genisleyebilir bir yapiya sahip:

- Full raw capture'lar external `KnowledgeMemory/raw/` altında immutable olarak tutulur.
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

### Karar: Public Engine ve Private Memory Ayrımı

Lothal.KnowledgeWiki'nin kalıcı rolü public engine/framework olmaktır. Repo şu varlıkları sürümler:

- kaynak capture ve ingest scriptleri
- agent promptları ve çalışma talimatları
- deterministik validation workflow'u
- reading path yapısı
- mimari ve kullanım dokümantasyonu
- public-safe örnekler
- raw kaynağı structured knowledge'a dönüştüren tekrar kullanılabilir mantık

Kullanıcının asıl belleği olan private `KnowledgeMemory` ise şunları saklar:

- full raw source capture'ları
- kişisel özetler ve generated notes
- private reading çıktıları
- inbox capture'ları
- prompt, review ve validation gibi run artefact'ları
- Obsidian tarafından okunabilen notlar

`KnowledgeMemory` bir Git repository olmak zorunda değildir. OneDrive, Google Drive, Obsidian Sync, Syncthing veya başka bir private sync mekanizmasıyla cihazlar arasında taşınabilir. Böylece public engine denetlenebilir ve paylaşılabilir kalırken kişisel asistan belleği private, uzun ömürlü ve kullanıcı kontrolünde olur.

Bu sınır gereklidir; çünkü public repo kullanıcının bütün kişisel hafızasına dönüşmemeli, raw capture ve generated private note hacmi engine tarihçesinden bağımsız biçimde büyüyebilmelidir. Public repo her kaynağı depolamak yerine sistemin nasıl çalıştığını belgelemeli ve sistemi iyileştirmelidir.

Önerilen private yapı:

```text
KnowledgeMemory/
  inbox/
  raw/
    articles/
    tweets/
    repos/
    videos/
  notes/
    concepts/
    syntheses/
    interview/
    projects/
    reading-paths/
  runs/
  home.md
```

2026-06-28 migration'ında mevcut raw capture'lar external `KnowledgeMemory/raw/` altına kopyalanıp doğrulandı ve public çalışma ağacından kaldırıldı. Generated `wiki/` notları taşınmadı. Git geçmişi yeniden yazılmadı.

### External Raw + Public Wiki Modeli

Private `KnowledgeMemory/raw/` source of truth olarak kalır; LLM bu katmanı değiştirmez. Public `wiki/` ise kaynaklardan türetilen, linklenen ve zaman içinde güncellenen bilgi katmanıdır. Wiki sayfaları private capture'ları repository path'i yerine `vault://raw/...` logical URI'larıyla izler.

Bu ayrim backend mimarisindeki event log ve read model ayrimina benzer. Ham kaynaklar audit edilebilir girdi, wiki sayfalari ise sorgulanabilir ve insan tarafindan tuketilebilir projeksiyondur.

Local-first software kaynağı bu proje için ek bir lens sunar: private memory ve public engine ayrı yaşam döngülerine sahip olsa da markdown tabanlı, kullanıcı kontrollü ve lokal okunabilir kalır. Bu repo tam anlamıyla collaborative CRDT uygulaması değildir; fakat veri sahipliği, uzun ömürlülük, offline okunabilirlik ve export edilebilir formatlar açısından local-first değerleriyle uyumludur.

## Agent Workflow Notes

`capture-and-prepare-ingest.ps1`, `-MemoryPath` ile capture'ları `<MemoryPath>/raw/` altına yazabilir. Generated note'ların `<MemoryPath>/notes/` ve run artefact'larının `<MemoryPath>/runs/` altına taşınması ayrı bir sonraki aşamadır. Public repo yalnızca public-safe wiki çıktıları ile engine script, prompt, validation ve dokümantasyon değişikliklerini almalıdır.

External raw akışında aşağıdaki davranış geçerlidir:

Ingest akisi su sekilde islemelidir:

- Ajan once `AGENTS.md` dosyasini okur.
- İlgili external raw kaynak incelenir ve değiştirilmez.
- Mevcut wiki sayfalari kontrol edilerek duplicate sayfa olusturulmaktan kacinilir.
- Gerekli konsept, synthesis, interview, project veya company sayfalari olusturulur ya da guncellenir.
- Sayfalar arasinda relative markdown linkleri kurulur.
- Kaynak referansı her sayfada `vault://raw/...` biçiminde korunur.
- `wiki/index.md` guncellenir.
- `wiki/log.md` dosyasina append-only kayit eklenir.

Aspire `AGENTS.md` ornegi, bu repoda talimatlarin daha da operasyonel hale getirilebilecegini gosterir. Sadece "Turkce yaz" veya "raw'a dokunma" gibi genel kurallar degil, hangi prompt'un ne zaman kullanilacagi, review'un hangi kalite kapilarini kontrol edecegi, source reference eksikliginin nasil ele alinacagi ve index/log tutarsizliklarinin nasil yakalanacagi da acik yazilabilir.

AI judgment kaynagi bu workflow'un neden sadece prompt template'lerinden ibaret olmamasi gerektigini netlestirir. Ingest prompt'u baslatma aracidir; asil kalite, agent ciktisinin kaynakla, mevcut wiki graph'iyle, insan review'uyla ve `validate-wiki.ps1` gibi deterministik kontrollerle kalibre edilmesinden gelir.

Two-track agentic development kaynagi bu projeye ek bir workflow prensibi getirir: daha cok agent calistirmak yerine bottleneck'i netlestirmek gerekir. Lothal.KnowledgeWiki'de source context ve raw content spec input gibi davranir; ingest bilgi uretimi, review ve validation ise verification hattidir.

Agent orchestration bu projede varsayılan değil, görev yapısı gerektirdiğinde kullanılan kontrollü bir optimizasyon olmalıdır. Büyük bir ingest sırasında duplicate taraması, teknik iddia analizi ve interview extraction gibi bağımsız okuma görevleri subagent'lara verilebilir. Ana agent sayfa planını, ortak terminolojiyi, source reference'ları ve final dosya değişikliklerini sahiplenmelidir. Aynı wiki dosyasını birden fazla agent'ın paralel düzenlemesi yerine kısmi sonuçlar ana agent'ta birleştirilmelidir; `validate-wiki.ps1` ise agent görüşünden bağımsız deterministik kalite kapısı olarak kalmalıdır.

Agent harness bakışı bu repository'deki parçaların rolünü netleştirir: `AGENTS.md` policy ve çalışma sözleşmesi, helper scriptler kontrollü tool yüzeyi, Git kalıcı çalışma alanı ve audit izi, `validate-wiki.ps1` ise deterministik kabul kapısıdır. Repo henüz durable run state, otomatik recovery veya risk-temelli approval sunan tam bir harness değildir; bu ayrım gelecekteki otomasyonu gereğinden fazla otonomlaştırmadan tasarlamak için korunmalıdır.

## Next Ideas

- `capture-and-prepare-ingest.ps1` için zorunlu olmayan bir `-MemoryPath` parametresi tasarlamak ve geriye dönük repo-local davranışı bilinçli biçimde ele almak.
- Ingest prompt ve helper scriptlerinde raw, notes ve runs köklerini aynı memory context üzerinden geçirmek.
- `KnowledgeMemory/notes/` için relative link ve source reference doğrulamasının repository dışı root üzerinde nasıl çalışacağını belirlemek.
- Private memory içindeki `home.md` ve `notes/reading-paths/` üretimini Obsidian kullanımına göre tanımlamak.
- Public-safe örnek seçme ve private içeriğin yanlışlıkla public repo'ya alınmasını engelleme kontrolü eklemek.
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

- `vault://raw/articles/karpathy-llm-wiki.md`
- `vault://raw/repos/aspire-agents-md.md`
- `vault://raw/articles/2026-06-20-local-first-software.md`
- `vault://raw/articles/2026-06-23-the-most-important-skill-in-the-age-of-ai-judgment.md`
- `vault://raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`
- `vault://raw/tweets/2026-06-27-agent-orchestration-explained.md`
- `vault://raw/tweets/2026-06-28-agent-harness-vs-classic-agent.md`

## Open Questions

- Legacy helper scriptlerde `-MemoryPath` verilmediğinde repo-local davranış korunmalı mı, yoksa private path açıkça zorunlu mu olmalı?
- Public engine, external `KnowledgeMemory` için template/bootstrap komutu sağlamalı mı?
- External memory validation sonuçları yalnızca `KnowledgeMemory/runs/` altında mı tutulmalı?
- Private ve public-safe örnekler arasında bilinçli export/redaction workflow'u gerekli mi?
