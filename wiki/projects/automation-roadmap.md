# Automation Roadmap

## Summary

Mevcut Lothal.KnowledgeWiki sistemi calisiyor: raw source eklenebiliyor, ingest prompt'u hazirlanabiliyor, review prompt'u uretilebiliyor, deterministik validation lokal ve GitHub Actions uzerinden calisabiliyor. Fakat workflow hala bircok manuel adim iceriyor.

Bu roadmap'in amaci, ingest/review/validation akisini kademeli olarak daha az manuel hale getirmek. Hedef tam otomatik ve kontrolsuz bir sistem kurmak degil; kullanicinin niyetini, source context'ini ve commit kararini koruyarak tekrar eden mekanik adimlari azaltmak.

Two-track agentic development kaynagi bu roadmap'e onemli bir sinir cizer: automation, sadece daha cok agent veya daha cok paralel is anlamina gelmemelidir. Once spec, implementation ve verification bottleneck'leri ayrilmali; sonra mekanik adimlar guvenli sekilde azaltılmalidir.

## Current Manual Workflow

1. Kaynak bulunur.
2. `scripts/new-source.ps1` calistirilir.
3. `Context Notes` elle doldurulur.
4. `Raw Content` markdown'a elle donusturulur veya kopyalanir.
5. Raw source commit edilir.
6. `scripts/ingest-prompt.ps1` calistirilir.
7. Prompt IDE agent/chat icine yapistirilir.
8. `scripts/review-prompt.ps1` calistirilir.
9. Review prompt icindeki ingest output placeholder'i ingest summary ile elle degistirilir.
10. `scripts/validate-wiki.ps1` calistirilir.
11. Commit/push yapilir.
12. GitHub Actions ayni validation adimini tekrar calistirir.

## Pain Points

- Raw Content capture hala manuel.
- Web sayfalarini markdown'a donusturmek manuel.
- Prompt copy/paste akisi manuel.
- Review prompt, ingest summary'nin elle yerlestirilmesini gerektiriyor.
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

## Phase 3.6 - Review Summary Automation

`scripts/review-prompt.ps1`, opsiyonel olarak ingest summary dosyasi kabul edecek sekilde gelistirilebilir. Bu, review prompt hazirlarken agent ciktisini elle prompt icine tasima ihtiyacini azaltir.

Olası kullanim:

```powershell
.\scripts\review-prompt.ps1 <raw-source-path> .agent/runs/example/ingest-summary.md
```

Bu yaklasimda ingest summary, once `.agent/runs/...` altinda saklanir; review helper ise source path ve summary dosyasini okuyup final review prompt'unu hazirlar.

Hedefler:

- Review prompt icindeki manuel summary yerlestirme adimini azaltmak.
- Agent run ciktisini daha sonra incelenebilir hale getirmek.
- Review ve validation kararlarini daha iyi audit edebilmek.

Bu fazda da LLM cagrisi yapilmamali. Script sadece prompt hazirlamali ve gerekirse clipboard'a kopyalamali.

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

## Recommended Order

1. Article/tweet/thread capture icin `scripts/capture-and-prepare-ingest.ps1` kullan.
2. `scripts/review-prompt.ps1` icin opsiyonel ingest summary dosyasi destegi ekle.
3. `.agent/runs/` icin minimal run artifact formatini dene.
4. Opsiyonel `scripts/open-reading.ps1` ile repo kokunu veya `wiki/index.md` dosyasini okuma ortaminda acmayi degerlendir.
5. Validation output'unu daha structured hale getir.
6. Commit assistant'i sadece karar destegi verecek sekilde tasarla.

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
- `scripts/review-prompt.ps1`
- `scripts/validate-wiki.ps1`
- `.github/workflows/validate-wiki.yml`
- `README.md`
- `raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`

## Open Questions

- `.agent/runs/` dizini Git'e alinmali mi, yoksa lokal audit artefact'i olarak mi kalmali?
- Helper scriptler clipboard kullanmali mi, yoksa sadece stdout'a mi yazmali?
- Commit assistant ne kadar otomatik olmali?
- LLM API entegrasyonu hangi kalite kapilarindan sonra dusunulmeli?
- Obsidian ayarlari uzun vadede Git'e alinmali mi, yoksa tamamen lokal mi kalmali?
