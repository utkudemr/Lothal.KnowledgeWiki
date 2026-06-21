# Phase 2 Status Report

## Summary

Phase 2, Lothal.KnowledgeWiki icin deterministik wiki validation katmanini ekledi. Bu fazdan once kalite kontrolu agirlikli olarak LLM review, insan okuması ve Git diff incelemesine dayaniyordu. Phase 2 ile repository artik temel yapisal dogruluk kontrollerini tekrar edilebilir bir PowerShell validator ile calistirabiliyor.

Phase 2.1 ile bu validator yerel kullanimdan cikarilip GitHub Actions uzerinden push ve pull request akışına da baglandi. Boylece wiki degisiklikleri sadece lokal olarak degil, remote CI ortaminda da otomatik kontrol ediliyor.

## What Was Completed

- `scripts/validate-wiki.ps1` eklendi.
- Validator gerekli root dosyalarini kontrol ediyor: `AGENTS.md`, `wiki/index.md`, `wiki/log.md`.
- Validator `wiki/**/*.md` icindeki relative markdown linkleri kontrol ediyor.
- Validator wiki sayfalarinda `Source References` bolumlerini kontrol ediyor.
- Validator raw source references ifadelerinin gercek kaynak arsivi dosyalarina isaret edip etmedigini kontrol ediyor.
- Validator placeholder/template kalintilarini warning olarak raporluyor.
- README icinde validation workflow dokumante edildi.
- Ingest prompt artik validation calistirmayi hatirlatiyor.
- Review prompt artik commit onerisi icin validation sonucunu gate olarak kullaniyor.
- GitHub Actions workflow `.github/workflows/validate-wiki.yml` konumunda eklendi.
- GitHub Actions validation push uzerinde basariyla calisti.

## Why This Matters

LLM review ve deterministik validation ayni kalite problemini cozmez. LLM review, ogrenme ve icerik kalitesine odaklanir: anlatim net mi, kaynak dogru yorumlanmis mi, .NET/backend baglami kurulmus mu, interview veya proje degeri var mi?

Deterministik validation ise repository correctness tarafini korur: gerekli dosyalar var mi, linkler kirik mi, source reference bolumleri unutulmus mu, raw path references gercek mi, template kalintilari kalmis mi?

Bu ayrim backend dunyasindaki code review ve test ayrimina benzer. Code review niyeti, tasarimi ve okunabilirligi yakalar; testler ve CI tekrar edilebilir dogruluk sinyali verir. Lothal.KnowledgeWiki icin de LLM review bilgi kalitesini, deterministik validation ise repo hijyenini guvence altina alir.

## Current Workflow

1. Raw source olusturulur.
2. `Context Notes` ve `Raw Content` doldurulur.
3. Raw source commit edilir.
4. Ingest prompt calistirilir.
5. Review prompt calistirilir.
6. `validate-wiki.ps1` calistirilir.
7. Sadece validation sonucu `Errors: 0` ise commit edilir.
8. GitHub Actions push uzerinde ayni validation adimini tekrar calistirir.

## Validation Rules

- Gerekli root dosyalarinin varligi kontrol edilir.
- `wiki/**/*.md` altindaki local relative `.md` linkleri dosya sisteminde cozulur.
- External URL, `mailto:`, anchor-only link ve absolute path kontrolleri kapsam disi birakilir.
- Belirli istisnalar disindaki wiki sayfalarinda `Source References` bolumu aranir.
- Markdown icerigindeki raw source references ifadelerinin mevcut kaynak arsivi dosyalarina isaret edip etmedigi kontrol edilir.
- Placeholder/template token'lari warning olarak raporlanir.
- Yaygin tamamlanmamis-is ve karar-bekliyor marker'lari case-insensitive warning olarak raporlanir.
- Error varsa script non-zero exit code ile biter; error yoksa basarili kabul edilir.

## Known Limitations

- Image linkleri henuz validate edilmiyor.
- Repo root'a gore absolute linkler su an skip ediliyor.
- Validation semantic kaliteyi kontrol etmiyor.
- Validation `index.md` ve `log.md` completeness durumunu derinlemesine dogrulamiyor.
- Warning kurallari hala basit token kontrollerinden olusuyor.

## Important Decisions

- Phase 2 teknolojisi simdilik PowerShell; bu, validation katmaninin mutlaka .NET CLI olmayacagi anlamina gelmez.
- Helper scriptler prompt/file helper olarak kalir ve LLM cagirmaya baslamaz.
- Validation commit oncesi deterministik gate olarak kullanilir.
- GitHub Actions remote safety check saglar ve lokal ortam farklarini yakalamaya yardim eder.

## Next Candidates

- Image linklerini validate etmek.
- `index.md` icinde tum wiki sayfalarinin yer aldigini kontrol etmek.
- `log.md` entry'lerini daha derin dogrulamak.
- CI icin opsiyonel JSON output eklemek.
- `source-add` ve `review` gibi validation mode flag'leri eklemek.
- Workflow'u test etmeye devam etmek icin yeni bir article ingest yapmak.

## Recommended Reading Order

1. [Phase 2 Status Report](phase-2-status-report.md)
2. [Phase 1 Status Report](phase-1-status-report.md)
3. [README](../../README.md)
4. [Ingest Source Prompt](../../.agent/prompts/ingest-source.md)
5. [Review Ingest Output Prompt](../../.agent/prompts/review-ingest-output.md)

## Related Pages

- [Lothal KnowledgeWiki](lothal-knowledgewiki.md)
- [Phase 1 Status Report](phase-1-status-report.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Instructions](../concepts/agent-instructions.md)

## Source References

- `scripts/validate-wiki.ps1`
- `.github/workflows/validate-wiki.yml`
- `.agent/prompts/ingest-source.md`
- `.agent/prompts/review-ingest-output.md`
- `README.md`

## Open Questions

- Validation script ne zaman PowerShell'den baska bir araca tasinmali?
- CI ciktisi ileride JSON veya artifact uretmeli mi?
- Semantic kalite kontrolu ile deterministic validation siniri nerede tutulmali?
