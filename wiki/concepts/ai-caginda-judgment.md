# AI Caginda Judgment

## Short Definition

AI caginda judgment, LLM veya agent ciktisini dogrudan kabul etmek yerine varsayimlarini, dogrulugunu, uygunlugunu ve risklerini bilincli sekilde degerlendirme becerisidir.

## Why It Matters

LLM'ler ikna edici, akici ve otoriter gorunen cevaplar uretebilir. Fakat bu cevaplar her zaman dogru, baglama uygun veya uygulanabilir degildir. Kaynagin ana iddiasi sudur: AI ile iyi sonuc alan kisileri ayiran asil beceri prompt ezberlemek degil, ciktidan sonra verilen kararlarin kalitesidir.

Bu nedenle judgment, AI workflow'unda sonradan eklenen bir review adimi degildir; hangi sorunun sorulacagindan, cevabin nasil sorgulanacagina ve neyin uygulanacagina kadar tum surece yayilir.

## Key Ideas

- Prompt playbook'lari baskasinin kelimelerini verebilir, ama baskasinin judgment'ini transfer edemez.
- LLM ciktisi en iyi yaklasimdan cok, egitim verisinde en cok belgelenmis yaklasimi yansitabilir.
- Judgment; belirsizlik altinda karar verme, dogru sorulari sorma, bilgiyi filtreleme ve yapisal hatalari fark etme becerilerinin birlesimidir.
- Iyi judgment tekrarlarla, domain bilgisiyle, karar sonuclarini izlemekle ve sureci kalibre etmekle gelisir.
- Bilgili suphecilik judgment'tir; bilgisiz suphecilik ise sadece inat olabilir.
- AI ciktisini degerlendirirken varsayimlari aciga cikarmak, alternatifleri istemek ve kanit seviyesini sorgulamak gerekir.

## Example

Bir LLM'e ".NET microservice icin nasil cache eklemeliyim?" diye soruldugunda model genellikle Redis, TTL, invalidation ve distributed cache desenlerini siralar. Bu cevap kotu olmak zorunda degildir; ama otomatik olarak dogru da degildir.

Judgment sahibi bir backend gelistirici su sorulari sorar:

- Bu response hangi trafik, veri tazeligi ve tutarlilik varsayimlarini yapiyor?
- Cache gercekten gerekiyor mu, yoksa sorgu veya indeks tasarimi mi bozuk?
- Bu veri kullaniciya stale gosterilirse is riski nedir?
- Redis eklemek operasyonel karmasiklik getirecek mi?
- Daha basit bir read model veya source-of-truth duzenlemesi ayni davranisi uretebilir mi?

Bu yaklasim, LLM ciktisini reddetmek degil; onu karar verme surecinde sorgulanabilir bir aday olarak kullanmaktir.

## .NET / Backend Relevance

.NET backend muhendisligi icin judgment, ozellikle system design ve production kararlarinda kritiktir:

- ASP.NET Core API tasariminda modelin onerisi REST, CQRS veya minimal API kaliplarindan birini abartabilir; asil soru domain davranisinin ne istedigidir.
- Microservice tasariminda LLM, populer oldugu icin Kubernetes, event bus veya distributed cache onerebilir; ama daha basit bir modular monolith veya background job yeterli olabilir.
- Observability, retry, outbox/inbox, rate limiting ve cache kararlarinda "en cok yazilmis desen" ile "bu sistem icin dogru davranis" ayni sey degildir.
- Agent workflow'larinda insan review'u ve deterministik validation, judgment'in surece kodlanmis halidir.

Lothal.KnowledgeWiki'de bu kavram somut olarak su ayrima denk gelir: agent ingest eder, insan review eder, `validate-wiki.ps1` mekanik kurallari kontrol eder. Bu uc katman birlikte, LLM ciktisini kalici bilgiye donusturmeden once kalibre eder.

## Interview Relevance

Bu konu "AI'i yazilim gelistirme surecinde nasil kullaniyorsun?" veya "LLM ciktisina ne kadar guvenirsin?" sorularinda kullanilabilir. Guclu cevap, AI'i hizlandirici olarak kullandigini ama karar sorumlulugunu devretmedigini anlatir: varsayim kontrolu, domain bilgisi, test, review, kaynak izlenebilirligi ve deterministic validation gibi kalite kapilarindan bahseder.

## Related Pages

- [Agent Workflow](agent-workflow.md)
- [Agent Instructions](agent-instructions.md)
- [LLM Wiki](llm-wiki.md)
- [Cache Karar Kriterleri](cache-karar-kriterleri.md)
- [Prompt Playbook vs Kalibre Judgment](../syntheses/prompt-playbook-vs-kalibre-judgment.md)
- [AI ciktilarini nasil degerlendirirsin?](../interview/ai-ciktilarini-nasil-degerlendirirsin.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `raw/articles/2026-06-23-the-most-important-skill-in-the-age-of-ai-judgment.md`

## Open Questions

- Judgment kalibrasyonu icin bu repoda karar log'u veya review checklist'i gibi daha structured bir artefact gerekli mi?
- AI ciktisindaki "en cok belgelenmis yaklasim" ile "bu proje icin en iyi yaklasim" ayrimini olcmek icin hangi pratik sorular standartlastirilmeli?
