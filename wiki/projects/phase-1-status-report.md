# Phase 1 Status Report

## Amaç

Lothal.KnowledgeWiki, teknik kaynaklari Git tabanli, markdown tabanli ve agent-assisted bir ogrenme wiki'sine donusturmek icin kurulan bir knowledge management reposudur.

Amac sadece not arsivlemek degildir. Ham kaynaklar `raw/` altinda korunur; ajanlar bu kaynaklari okuyup `wiki/` altinda Turkce, baglantili, review edilebilir ve tekrar kullanilabilir ogrenme artefaktlari uretir. Bu yapi .NET backend gelistirici icin konsept notlari, synthesis sayfalari, interview hazirligi ve proje kararlarini ayni yerde biriktirmeyi hedefler.

## Mevcut Mimari

- `raw/`, immutable source archive olarak calisir. Makale, repo notu, video transkripti, interview sorusu veya chat ozeti gibi kaynaklar burada saklanir ve eklendikten sonra degistirilmez.
- `wiki/`, generated learning/read-model layer olarak calisir. Ajanlar ham kaynaklardan turetilmis konsept, synthesis, project ve interview sayfalari uretir.
- `AGENTS.md`, repository instruction contract rolunu ustlenir. Ajanin hangi dizinlere dokunabilecegini, nasil yazacagini, source reference ve log/index kurallarini belirler.
- `.agent/prompts/`, tekrar kullanilabilir prompt template'lerini tasir. Su an path-based ingest ve ingest review akislari icin promptlar vardir.
- `.agent/templates/`, tekrar kullanilabilir source template'lerini tasir. Yeni raw kaynaklar icin standart metadata ve context notes yapisi saglar.
- Git commit'leri audit/history katmanidir. Raw kaynak ekleme, wiki ingest, review ve rapor guncellemeleri commit'lerle izlenebilir hale gelir.
- Obsidian opsiyonel okuma ve navigasyon katmani olabilir. Markdown dosyalari dogrudan Obsidian vault gibi okunabilir; fakat sistem Obsidian'a bagimli degildir.

## Tamamlanan İşler

- Initial repo structure olusturuldu.
- `AGENTS.md` kurallari yazildi ve wiki bakim sozlesmesi haline getirildi.
- Karpathy LLM Wiki kaynagi ingest edildi.
- Aspire `AGENTS.md` kaynagi ingest edildi.
- `wiki/reading-guide.md` ile wiki ciktisini nasil okumak gerektigi aciklandi.
- `.agent/prompts/ingest-source.md` path-based ingest prompt template olarak guncellendi.
- `.agent/prompts/review-ingest-output.md` review prompt template olarak eklendi.
- `.agent/templates/source.md` raw source template olarak eklendi.
- Synthesis sayfasi varsa recommended reading order icinde once synthesis okunmasi kurali benimsendi.

## Öğrenilenler

Ilk kaynak olan Karpathy LLM Wiki, RAG ile LLM-maintained wiki arasindaki farki netlestirdi. RAG query-time retrieval ile cevap uretmeye odaklanirken, LLM Wiki ingest-time sentez ve kalici markdown bilgi katmani uretir.

Bu ayrim `raw/` ve `wiki/` mimarisini dogurdu: `raw/` source of truth, `wiki/` ise turetilmis projection/read model olarak dusunulur. Bu model backend'deki event log ve read model ayrimina benzer.

Aspire `AGENTS.md` kaynagi, agent instruction dosyalarinin gercek repository workflow icinde operasyonel contract gibi calistigini gosterdi. Buyuk bir .NET repo'da talimatlar sadece kod stili degil; generated dosyalar, restore/build/test komutlari, CI hassasiyetleri, flaky testler, localization ve maintainer guidance gibi kurallari da tasir.

Bu kaynaklardan coding-agent instructions ile knowledge/wiki-agent instructions arasindaki fark da netlesti. Coding agent gercek kodu degistirir ve build/test/CI ile dogrulanir. Knowledge wiki agent ise ham kaynaktan bilgi read model uretir ve source reference, link dogrulugu, index/log disiplini, duplicate onleme ve human review ile dogrulanir.

Review quality gate'leri bu yuzden onemlidir. Ajanin urettigi metin okunabilir olsa bile, kaynak referansi yoksa, linkler kiriksa, index/log guncellenmediyse veya sentez iddiasi kaynaga dayanmiyorsa wiki uzun vadede guvenilmez hale gelir.

## Mevcut Workflow

1. `.agent/templates/source.md` kullanilarak yeni raw source olusturulur.
2. Raw source commit edilir.
3. `.agent/prompts/ingest-source.md` kullanilarak raw source path uzerinden ingest yapilir.
4. `.agent/prompts/review-ingest-output.md` kullanilarak ingest ciktisi review edilir.
5. `wiki/reading-guide.md` kullanilarak uretilen sayfalar etkin okuma sirasiyla tuketilir.
6. Wiki degisiklikleri commit edilir.

## Güçlü Taraflar

- `raw/` ve `wiki/` ayrimi temizdir.
- Uretilen ogrenme ciktisi Turkce ve backend odaklidir.
- Source reference kurali bilgi izlenebilirligini korur.
- `wiki/index.md` navigasyon, `wiki/log.md` audit trail saglar.
- Review adimi kalite kapisi olarak tasarlanmistir.
- Prompt ve source template'leri tekrar kullanilabilir durumdadir.
- Git tabanli tarihce hem insan review'u hem de geri donus icin uygundur.

## Zayıf Taraflar / Sorunlar

- Surec hala manueldir.
- Prompt kullanimi hala copy-paste tabanlidir.
- Henuz validation CLI yoktur.
- Henuz broken relative link checker yoktur.
- Henuz otomatik source creation script yoktur.
- Markdown ve `index.md` disinda arama/indexleme katmani yoktur.
- Review kalite kapilari tanimli olsa da otomatik olarak zorlanmamaktadir.

## Faz 1 Kabul Durumu

Faz 1 genel olarak basarili ve manuel workflow olarak kabul edilebilir durumdadir.

Repo artik ham kaynak ekleme, ingest, review, okuma ve commit etme adimlarini destekleyen calisan bir bilgi uretim dongusune sahiptir. Karpathy ve Aspire kaynaklari farkli tur bilgi uretimini test etti: biri LLM Wiki/RAG mimarisini, digeri agent instruction ve repository workflow disiplinini netlestirdi.

Faz 1 kapanmadan once kucuk temizlik olarak README icinde daha kisa bir usage bolumu yazilabilir, raw source olusturma ve prompt calistirma adimlari daha gorunur hale getirilebilir, ayrica Obsidian kullanimi opsiyonel not olarak eklenebilir.

## Faz 1.5 İçin Önerilen Sonraki Adımlar

- `scripts/new-source.ps1`: template uzerinden yeni raw source dosyasi olusturan yardimci script.
- `scripts/ingest-prompt.ps1`: verilen raw path icin ingest prompt'unu hazirlayan script.
- `scripts/review-prompt.ps1`: verilen raw path veya son ingest icin review prompt'unu hazirlayan script.
- Opsiyonel Obsidian usage notes: vault olarak nasil acilacagi, index ve reading guide'in nasil kullanilacagi.
- README icinde daha kucuk ve pratik usage section: "new source -> commit raw -> ingest -> review -> commit wiki".

## Faz 2 İçin Önerilen Sonraki Adımlar

- .NET validation CLI gelistirmek.
- Source reference validation: her wiki sayfasinda raw path var mi ve path mevcut mu?
- Broken relative link validation: markdown linkleri gercek dosyalara cozunuyor mu?
- Required section validation: concept/synthesis/interview/project sayfalari beklenen basliklara sahip mi?
- Index/log validation: yeni veya guncellenen sayfalar index/log tarafinda izleniyor mu?
- Raw immutability check: commit veya validation asamasinda mevcut raw dosyalara beklenmeyen edit var mi?

## Recommended Reading Order

1. [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
2. [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md)
3. [LLM Wiki](../concepts/llm-wiki.md)
4. [Agent Instructions](../concepts/agent-instructions.md)
5. [Lothal KnowledgeWiki](lothal-knowledgewiki.md)
6. [Reading Guide](../reading-guide.md)

## Related Pages

- [Lothal KnowledgeWiki](lothal-knowledgewiki.md)
- [LLM Wiki](../concepts/llm-wiki.md)
- [Agent Instructions](../concepts/agent-instructions.md)
- [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
- [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md)

## Source References

- `vault://raw/articles/karpathy-llm-wiki.md`
- `vault://raw/repos/aspire-agents-md.md`

## Open Questions - Decisions

### Faz 1.5'te once script tabanli prompt hazirlama mi, README/Obsidian kullanim notlari mi yapilmali?

Karar: Oncelik script tabanli prompt hazirlama olmali.

Gerekce:
Mevcut workflow calisiyor ancak kaynak olusturma, ingest prompt hazirlama ve review prompt hazirlama adimlari hala manuel. Bu yuzden ilk iyilestirme gunluk kullanimdaki surtunmeyi azaltmalidir. README ve Obsidian notlari daha sonra kisa kullanim rehberi olarak eklenebilir.

Oncelik sirasi:
1. `scripts/new-source.ps1`
2. `scripts/ingest-prompt.ps1`
3. `scripts/review-prompt.ps1`
4. README'ye kisa kullanim bolumu
5. Obsidian kullanim notu

### Faz 2 validation CLI dogrudan .NET ile mi baslamali, yoksa once PowerShell kontrolleriyle mi denenmeli?

Karar: Faz 2 validation CLI dogrudan .NET ile baslamali.

Gerekce:
PowerShell helper scriptleri Faz 1.5 icin yeterlidir. Ancak validation tarafi projenin muhendislik degerini artiran kalici bir bilesen olacagi icin .NET CLI olarak gelistirilmelidir. Bu sayede markdown/wiki validation kurallari test edilebilir, genisletilebilir ve portfoy degeri daha yuksek olur.

Decision:
Faz 1.5 helper scripts PowerShell ile yapilacak.
Faz 2 validation CLI .NET ile gelistirilecek.
