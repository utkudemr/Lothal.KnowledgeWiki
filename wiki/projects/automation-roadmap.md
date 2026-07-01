# Automation Roadmap

## Summary

Mevcut Lothal.KnowledgeWiki sistemi calisiyor: raw source eklenebiliyor, ingest prompt'u hazirlanabiliyor, review prompt'u uretilebiliyor, deterministik validation lokal ve GitHub Actions uzerinden calisabiliyor. Fakat workflow hala bircok manuel adim iceriyor.

Bu roadmap'in amaci, ingest/review/validation akisini kademeli olarak daha az manuel hale getirmek. Hedef tam otomatik ve kontrolsuz bir sistem kurmak degil; kullanicinin niyetini, source context'ini ve commit kararini koruyarak tekrar eden mekanik adimlari azaltmak.

Roadmap'in yeni mimari sınırı şudur: Lothal.KnowledgeWiki public engine/framework olarak kalır; gerçek kişisel içerik ayrı ve private `KnowledgeMemory` altında büyür. Automation yalnızca adım sayısını değil, engine ile memory arasındaki storage sınırını da güvenli biçimde yönetmelidir.

Two-track agentic development kaynagi bu roadmap'e onemli bir sinir cizer: automation, sadece daha cok agent veya daha cok paralel is anlamina gelmemelidir. Once spec, implementation ve verification bottleneck'leri ayrilmali; sonra mekanik adimlar guvenli sekilde azaltılmalidir.

## Target Storage Architecture

Public repository scriptleri, promptları, validation workflow'unu, reading path yapısını, dokümantasyonu ve public-safe örnekleri içerir. Private `KnowledgeMemory` full raw capture'ları, kişisel ve generated note'ları, reading çıktılarını, inbox içeriğini ve run artefact'larını saklar.

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
  insights/
    articles/
    tweets/
    repos/
    videos/
  runs/
    ingest-summaries/
    review-results/
    reading-orders/
  home.md
```

Bu klasör Git repository olmak zorunda değildir; OneDrive, Google Drive, Obsidian Sync, Syncthing veya başka bir private sync mekanizmasıyla senkronize edilebilir. 2026-06-28 migration'ında public raw capture'lar bu yapıya taşındı ve doğrulamadan sonra aktif çalışma ağacından kaldırıldı; `wiki/` notları yerinde kaldı ve Git geçmişi yeniden yazılmadı.

## Current Manual Workflow

1. Kaynak bulunur.
2. `scripts/new-source.ps1` calistirilir.
3. `Context Notes` elle doldurulur.
4. `Raw Content` markdown'a elle donusturulur veya kopyalanir.
5. Raw source commit edilir.
6. `scripts/ingest-prompt.ps1` calistirilir.
7. Prompt IDE agent/chat icine yapistirilir.
8. Ingest summary clipboard'a kopyalanir ve `scripts/save-ingest-summary.ps1` ile run dizinine kaydedilir.
9. `scripts/review-prompt.ps1`, kaydedilen summary path'i ile calistirilir.
10. `scripts/validate-wiki.ps1` calistirilir.
11. Commit/push yapilir.
12. GitHub Actions ayni validation adimini tekrar calistirir.

## Pain Points

- Raw Content capture hala manuel.
- Web sayfalarini markdown'a donusturmek manuel.
- Prompt copy/paste akisi manuel.
- Ingest summary'nin agent ciktisindan clipboard'a kopyalanmasi hala manuel.
- Validation CI tarafinda calissa da lokal olarak elle calistiriliyor.
- Agent run output'lari structured bir sekilde arsivlenmiyor.
- Commit mesajlari ve final commit kararlari hala manuel.

## Phase 3 - Start Ingest Helper

`scripts/start-ingest.ps1` MVP olarak eklendi. Yeni bir kaynagi ingest workflow'una sokmak icin `new-source.ps1` ve `ingest-prompt.ps1` adimlarini tek komutta birlestirir.

Hedefler:

- Raw source dosyasini olusturmak. (MVP: tamamlandi)
- Kullaniciya sonraki adimlari yazdirmak. (MVP: tamamlandi)
- Ingest prompt'unu hazirlamak ve clipboard'a kopyalamak. (MVP: tamamlandi)
- Hatirlanmasi gereken komut sayisini azaltmak. (MVP: tamamlandi)
- `raw/` dosyasinin once insan tarafindan doldurulmasi gerektigini net gostermek. (MVP: tamamlandi)

Bu fazda script LLM cagirmamali. Sadece dosya, prompt ve yonlendirme yardimcisi olarak kalmali. Boylece sistem, Phase 1.5'teki guvenli helper script modelini bozmadan daha ergonomik hale gelir.

Kullanim:

```powershell
.\scripts\start-ingest.ps1 article "Article Title" "https://example.com/article"
```

Beklenen cikti:

- Olusturulan raw dosya path'i.
- Doldurulmasi gereken alanlar.
- Raw source commit onerisi.
- Ingest prompt'unu hazirlama veya kopyalama adimi.
- Validation ve review hatirlatmasi.

MVP bilincli olarak URL icerigini fetch etmez, LLM cagirmasi yapmaz, wiki dosyalarini degistirmez ve commit atmaz. Bu nedenle workflow hala insanin source context'ini ve raw content'i bilincli sekilde doldurmasini zorunlu tutar.

## Phase 3.5 - Preferred Source Capture Workflow

`scripts/capture-and-prepare-ingest.ps1`, browser'dan kopyalanan markdown veya metni tek komutla yeni raw source dosyasina aktarir. Varsayilan Context Notes alanini doldurur, ingest prompt'unu clipboard'a kopyalar ve wiki validation'i calistirir.

Bu akış, çoğu article/tweet/thread capture işlemi için daha manuel olan `start-ingest.ps1` + `import-clipboard-source.ps1` akışının yerini alan tercih edilen yöntemdir:

```powershell
.\scripts\capture-and-prepare-ingest.ps1 article "Article Title" "https://example.com/article"
```

URL fetching bilinçli olarak ertelenmiştir. Sitelerin HTML yapısı, erişim kuralları ve client-side rendering davranışları farklıdır; şimdilik browser reader mode veya MarkDownload üzerinden alınan, kullanıcının görebildiği markdown/metin daha güvenilir bir capture sınırı sağlar. Script LLM çağırmaz, commit atmaz ve yeni oluşturduğu raw source dışında `raw/` içeriğini değiştirmez.

## Phase 3.6 - Run Archive and Review Automation

`scripts/save-ingest-summary.ps1`, clipboard'daki ingest summary'yi source slug'ına ait `.agent/runs/...` dizinine kaydeder ve `source-path.txt` ile kaynak izini korur. `scripts/review-prompt.ps1` opsiyonel ikinci argüman olarak bu summary dosyasını kabul eder ve review prompt'undaki ingest-output placeholder'ını otomatik doldurur. Böylece ingest ile review arasındaki manuel kopyala-yapıştır ve placeholder değiştirme adımı azalır.

Kullanım:

```powershell
.\scripts\save-ingest-summary.ps1 <raw-source-path>
.\scripts\review-prompt.ps1 <raw-source-path> .agent/runs/example/ingest-summary.md
```

Tek argümanlı `review-prompt.ps1` kullanımı geriye dönük uyumluluk için korunur; bu durumda prompt ingest-output placeholder'ı ile üretilir ve manuel akışa devam edilebilir.

Hedefler:

- Review prompt içindeki manuel summary yerleştirme adımını azaltmak. (tamamlandı)
- Agent run çıktısını daha sonra incelenebilir hale getirmek. (ingest summary için tamamlandı)
- Source ile run artefact'ı arasındaki izi korumak. (tamamlandı)

Bu fazda LLM çağrısı veya commit oluşturma yoktur. Gelecekte aynı run dizinine review sonucunu kaydetmek, validation çıktısını yakalamak ve kullanıcının inceleyebileceği bir commit komutu hazırlamak mümkündür.

## Phase 4 - Run Artifact Archive

Agent calismalarinin ciktisi structured olarak arsivlenebilir. Ornek dizin:

```text
.agent/runs/
  2026-06-21-example-source/
    ingest-prompt.md
    ingest-summary.md
    review-prompt.md
    review-result.md
    validation-output.txt
```

Bu arsiv, wiki iceriginden farkli bir operasyonel iz olur. `wiki/` kalici bilgi katmani olarak kalirken `.agent/runs/` agent calisma gecmisi, review sonucu ve validation ciktisi icin kullanilir.

Onemli karar: Bu dizinin Git'e alinip alinmayacagi ayrica belirlenmelidir. Kisa vadede yerel audit icin faydali olabilir; uzun vadede gürültü uretirse ignore edilebilir veya sadece secili raporlar commit edilebilir.

## Phase 4.1 - External KnowledgeMemory Path (Completed)

`scripts/capture-and-prepare-ingest.ps1`, `-MemoryPath` parametresiyle private veya synced bir KnowledgeMemory altında raw source capture oluşturur ve generated knowledge output'larını external `notes/` katmanına yönlendirir. External mode, tüm note folder hedeflerini, `vault://raw/<source-type>/<filename>.md` logical reference'ını ve private insight hedefini prompt'a ekler. Repo-local davranış yalnızca legacy/demo/public-example uyumluluğu olarak kalır.

Başlatılan kapsam:

- Raw source capture'larını `<MemoryPath>/raw/<source-type>/` altına yazmak. (tamamlandı)
- External raw source için özel ingest prompt'u üretmek ve clipboard'a kopyalamak. (tamamlandı)
- Mevcut repo-local davranışı geriye uyumlu tutmak. (tamamlandı)
- Var olmayan `MemoryPath` değerini açık hata ve non-zero exit code ile reddetmek. (tamamlandı)
- `notes/concepts`, `notes/syntheses`, `notes/interview`, `notes/projects`, `notes/reading-paths`, `insights/<source-type>`, `runs/ingest-summaries`, `runs/review-results`, `runs/reading-orders` ve `inbox` parent klasörlerini hazırlamak. (tamamlandı)
- MemoryPath ingest sırasında public `wiki/`, `wiki/index.md` ve `wiki/log.md` yazımını prompt seviyesinde yasaklamak. (tamamlandı)

## Phase 4.2 - External Notes and Private Insight Output (Completed)

Bu adım, reusable generated knowledge ile kişisel öğrenme çıktısını external memory içinde fiziksel olarak ayırır; ikisini de public repository'den uzak tutar.

Uygulanan kapsam:

- `<MemoryPath>/insights/<source-type>/<date-slug>-insights.md` hedefini hesaplamak.
- Insight parent dizinini oluşturmak ve hedef path'i external ingest prompt'una eklemek.
- Generated concept, synthesis, interview, project ve reading-path notlarını `<MemoryPath>/notes/` altına yönlendirmek.
- Generated notes'u mümkün olduğunca reusable tutarken private/synced memory output olarak tanımlamak.
- Kişisel, şirket/proje/kariyer bağlantılarını ve private reading refleksiyonlarını yalnızca insight note'a yönlendirmek.
- Insight note için Türkçe öğrenme/refleksiyon bölümlerini tanımlamak ve raw içeriğin verbatim kopyalanmasını yasaklamak.

Kabul adımları:

- Workflow'u gerçek bir private `KnowledgeMemory` üzerinde uçtan uca denemek.
- Insight note'un mevcut olması durumunda create/update davranışını doğrulamak.
- Public diff içinde source-specific generated note, fiziksel memory path veya private reflection kalmadığını review adımında kontrol etmek.

Sonraki kapsam:

- Ingest/review run helper'larını hazırlanmış `<MemoryPath>/runs/` klasörlerine yazacak şekilde genişletmek.
- Gerekirse `<MemoryPath>/inbox/` içinden capture alma akışını desteklemek.
- External memory dosya hedeflerini isteğe bağlı olarak doğrulamak. Public validator `vault://raw/...` URI'larını kabul eder fakat private dosyanın public repository içinde var olmasını istemez. (logical URI desteği tamamlandı)
- MemoryPath root'unu da oluşturabilen ayrı bir bootstrap workflow'u değerlendirmek.
- Public repository'ye yalnızca script, prompt, validation ve dokümantasyon iyileştirmeleri bırakmak.

Mevcut `.agent/runs/` davranışı repo-local demo MVP olarak kalır. MemoryPath modunda source-specific generated knowledge `KnowledgeMemory/notes/`, kişisel insight output `KnowledgeMemory/insights/` altında yaşar; public `wiki/` yalnızca legacy/demo/public-example içeriğidir.

## Phase 4.3 - External Reading Order and Home Navigation (Completed)

MemoryPath ingest prompt'u, generated notes ve insight tamamlandıktan sonra `<MemoryPath>/runs/reading-orders/<date-slug>-reading-order.md` dosyasını üretmeyi zorunlu kılar. Reading-order note kaynak türünü, `vault://raw/...` logical reference'ını, created-note listesini, önerilen okuma sırasını, bu sıranın gerekçesini ve opsiyonel takip sorularını içerir. Generated note bağlantılarında mümkün olduğunda Obsidian wiki linkleri kullanılır.

`<MemoryPath>/home.md` private memory'nin hafif navigation girişidir. Dosya yoksa oluşturulur; varsa `Recent Ingests` altındaki source entry eklenir veya güncellenir. Home entry ayrıntıları tekrar etmez, yalnızca ilgili reading-order note'a bağlanır. Reading-order ve home çıktıları source-specific private memory artefact'larıdır; public repository'ye yazılmaz veya commit edilmez.

## Phase 4.4 - Cross-source Linking and Memory Maps (Completed)

MemoryPath ingest akisi artik yeni kaynagi mevcut external notlarla anlamsal olarak baglar ve hafif memory map'leri gunceller.

Uygulanan kapsam:

- Mevcut concept, synthesis, interview ve reading-path notlarini ingest oncesinde incelemek.
- Mumkun oldugunda 3-7 somut iliskiyi kontrollu bir iliski tipiyle siniflandirmak; sirf kota doldurmak icin link uretmemek.
- Generated notlara `Hafiza Baglantilari`, reading-order notlarina `Baglantili Okuma` yapisini eklemek.
- External `maps/concept-index.md` icinde hafif concept navigasyonu tutmak.
- External `maps/source-graph.md` icinde source-to-note ve note-to-note baglantilarini izlemek.
- Yalnizca acikca faydali oldugunda `maps/topics/<topic-slug>.md` guncellemek.
- Ingest prompt'unu source-specific external run klasorunde kalici hale getirmek.

Gelecek calismalar:

- Automated similarity search.
- Tag extraction.
- Backlink validation.
- Stale/duplicate note detection.
- Full automated ingest runner.

## Phase 4.5 - Validation Ergonomics

Validation su an dogru yerde duruyor: lokal script ve GitHub Actions gate'i. Sonraki ergonomi iyilestirmeleri sunlar olabilir:

- `scripts/validate-wiki.ps1` icin daha okunabilir summary format'i.
- Opsiyonel JSON output.
- CI icin machine-readable output.
- Mode flag'leri: `source-add`, `ingest-review`, `full`.
- `index.md` ve `log.md` completeness kontrollerini guclendirme.
- Image link validation ekleme.

Bu fazin amaci yeni kurallar eklemek kadar validation sonucunu daha kullanilabilir hale getirmektir.

## Phase 4.6 - Reading UX

Okuma deneyimi automation ve usability iyilestirmelerinin parcasi olarak ele alinmali. Bu repo markdown tabanli kaldigi icin kok dizin Obsidian vault olarak acilabilir; boylece `wiki/` sayfalari linkler, backlinks, graph ve canvas uzerinden okunabilir.

Bu rol ayrimi korunmali:

- Rider / VS Code: scriptler, promptlar, agent calismasi, validation, diff review ve commit.
- Obsidian: okuma, linkler arasinda gezinme, backlinks, graph/canvas kesfi ve tekrar calisma.

Obsidian opsiyoneldir. Git, `scripts/validate-wiki.ps1`, agent ingest/review akisi veya commit disiplininin yerine gecmemelidir. `.obsidian/` klasoru varsayilan olarak Git disinda kalmali; ayarlarin versiyonlanmasi daha sonra bilincli bir karar olarak degerlendirilmelidir.

## Phase 5 - Commit Assistant

Commit assistant, validation sonucunu okuyup commit oncesi karar destegi verebilir. Bu arac otomatik commit atmamalidir; sadece kullaniciya hazirlik raporu sunmalidir.

Olası sorular:

- Hangi dosyalar degisti?
- `raw/` altinda beklenmeyen degisiklik var mi?
- Validation sonucu temiz mi?
- `wiki/index.md` ve `wiki/log.md` guncellenmis mi?
- Onerilen commit mesaji ne olabilir?

Bu asamada final karar yine insanda kalmali. Knowledge base kalitesini korumak icin otomatik commit/push davranisi ertelenmelidir.

## Non-Goals For Now

- Helper scriptlerin dogrudan LLM API cagirarak ingest yapmasi.
- Raw source icerigini otomatik degistirmek.
- Review adimini tamamen kaldirmak.
- Semantic kalite kontrolunu deterministik validation icine zorla sikistirmak.
- Git commit ve push islemlerini kullanici onayi olmadan otomatik yapmak.
- Mevcut historical `wiki/` notlarını otomatik olarak private memory'ye taşımak.
- `KnowledgeMemory` klasörünü zorunlu olarak Git repository yapmak.
- Private raw source veya generated note'ları rutin olarak public repository'ye commit etmek.

## Recommended Order

1. `capture-and-prepare-ingest.ps1 -MemoryPath` raw capture + external notes + private insight akışını PostgreSQL gibi bir kaynakla uçtan uca dene.
2. Ingest summary, review result ve validation output'u `KnowledgeMemory/runs/` altında arşivlemeyi destekle.
3. İsteğe bağlı external-memory doğrulamasını public validator'dan ayrı bir sınır olarak tasarla.
4. Private `home.md`, reading-order ve reading-path açma akışını Obsidian ile test et.
5. KnowledgeMemory klasör yapısı için bootstrap ve public-safe export/redaction sınırını tanımla.
6. Validation output'unu daha structured hale getir ve commit assistant'i yalnızca public engine değişiklikleri için karar desteği verecek şekilde tasarla.

## .NET / Backend Relevance

Bu roadmap, backend sistemlerdeki pipeline tasarimina benzer: once manuel ama guvenli adimlar kurulur, sonra tekrarlanabilir bolumler automation'a tasinir, en son karar noktalarina guardrail eklenir.

Lothal.KnowledgeWiki icin `raw/` event log gibi, `wiki/` read model gibi, validation ise CI gate gibi dusunulebilir. Automation arttikca asil hedef, bilgi uretimini hizlandirmak ama source traceability ve review disiplinini kaybetmemektir.

## Related Pages

- [Lothal KnowledgeWiki](lothal-knowledgewiki.md)
- [Phase 2 Status Report](phase-2-status-report.md)
- [Phase 1 Status Report](phase-1-status-report.md)
- [Two-Track Agentic Development](../concepts/two-track-agentic-development.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Instructions](../concepts/agent-instructions.md)

## Source References

- `wiki/projects/phase-2-status-report.md`
- `wiki/projects/phase-1-status-report.md`
- `scripts/new-source.ps1`
- `scripts/capture-and-prepare-ingest.ps1`
- `scripts/ingest-prompt.ps1`
- `scripts/save-ingest-summary.ps1`
- `scripts/review-prompt.ps1`
- `scripts/validate-wiki.ps1`
- `.github/workflows/validate-wiki.yml`
- `README.md`
- `vault://raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`

## Open Questions

- Legacy/demo modu uzun vadede ayrı bir explicit switch gerektirmeli mi?
- Existing insight note için agent create/update kararını belirleyen ek bir metadata veya merge kuralı gerekli mi?
- External insight note yapısı ayrı bir validator ile doğrulanmalı mı?
- Mevcut `.agent/runs/` içeriği yerinde mi kalmalı, yoksa ayrı bir migration ile `KnowledgeMemory/runs/` altına mı taşınmalı?
- Validator aynı script ile hem public repo'yu hem external memory'yi doğrulamalı mı?
- `KnowledgeMemory` klasör yapısını oluşturacak ayrı bir bootstrap scripti gerekli mi?
- Public-safe örneklerin private memory'den çıkarılması için redaction/export adımı gerekli mi?
- Helper scriptler clipboard kullanmali mi, yoksa sadece stdout'a mi yazmali?
- Commit assistant ne kadar otomatik olmali?
- LLM API entegrasyonu hangi kalite kapilarindan sonra dusunulmeli?
- Obsidian ayarlari uzun vadede Git'e alinmali mi, yoksa tamamen lokal mi kalmali?
