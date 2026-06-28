# Agent Instructions

## Short Definition

Agent instructions, bir repository icinde LLM tabanli ajanlara proje kurallarini, dosya sinirlarini, kalite kapilarini, dogrulama komutlarini ve maintainer beklentilerini anlatan surumlenebilir talimat katmanidir.

## Why It Matters

Buyuk bir repository'de ajan sadece "kod yazan" bir arac degildir; build sistemi, test runner, generated dosyalar, public API kurallari, localization, CI davranisi ve takim convention'lariyla birlikte calisir. Bu baglam yazilmazsa ajan dogru gorunen ama repo icin riskli degisiklikler yapabilir.

Microsoft Aspire kaynaginda `AGENTS.md`, ajana yalnizca genel stil tercihi vermiyor. Hangi dosyalara dokunulmamasi gerektigini, hangi test komutlarinin guvenli oldugunu, hangi CI yollarinin kirilgan oldugunu, hangi ozel skill'lerin ne zaman kullanilacagini ve hangi pattern'lerde ek talimatlarin devreye girecegini acikliyor. Bu, agent instructions dosyasini repository'nin operasyonel hafizasi haline getirir.

## Key Ideas

- Talimatlar repository'nin gercek is akisina gomuludur; sadece genel prompt tavsiyesi degildir.
- "Dokunma" kurallari en az "yap" kurallari kadar onemlidir: generated API dosyalari, lock/config dosyalari, localization dosyalari gibi alanlar korunur.
- Dogrulama komutlari agent icin acik olmalidir: restore, build, targeted test, filter kullanimi, timeout ve flaky test kurallari.
- Code review beklentileri ayri yazilmalidir: neyin flaglenecegi, neyin normal oldugu ve hangi durumlarda yorum yapilmamasi gerektigi belirtilir.
- Pattern-based talimatlar buyuk repo icin olcekleme saglar; farkli dizinler farkli uzmanlik kurallari alabilir.
- Talimat dosyasi zamanla bir maintainer guidance dokumanina donusur.

## Example

Aspire kaynaginda test calistirma talimatlari sadece "`dotnet test` calistir" seviyesinde degildir. Repository'nin Microsoft.Testing.Platform kullandigi, VSTest tarzindaki `--filter` argumaninin problemli olabilecegi, filtrelerin `--` sonrasinda verilmesi gerektigi ve quarantined/outerloop testlerin otomasyonlarda dislanmasi gerektigi acikca yazilir.

Bu tur bir talimat, ajan davranisini dogrudan iyilestirir. Ajan hem dogru komutu secmeyi hem de hangi dogrulamanin guvenilir oldugunu ogrenir.

Lothal.KnowledgeWiki'de ayni desen su sekilde uygulanir: ajan once `AGENTS.md` dosyasini okur, sonra external `KnowledgeMemory/raw/` altindaki kaynagi sadece okur, `wiki/` altinda ilgili sayfalari olusturur veya gunceller, `vault://raw/...` source reference'ini korur, `wiki/index.md` ve `wiki/log.md` dosyalarini gunceller. Buradaki kalite kapisi build/test degil; izlenebilirlik, link dogrulugu, duplicate onleme ve ogrenme degeridir.

## .NET / Backend Relevance

.NET backend repository'lerinde agent instructions ozellikle degerlidir cunku build ve test davranisi cogu zaman proje ozelidir:

- `global.json` SDK pinning nedeniyle restore/build sirasi onemli olabilir.
- Public API surface generated dosyalarla takip edilebilir.
- NuGet feed configuration internal pipeline icin kritik olabilir.
- xUnit, Microsoft.Testing.Platform, snapshot testing veya custom test trait'leri farkli komut disiplinleri gerektirebilir.
- Distributed app veya Aspire gibi platform repo'larinda dashboard, hosting, CLI, integration packages ve CI farkli sahiplik alanlarina sahip olabilir.

Bu nedenle iyi bir `AGENTS.md`, sadece kod stilini degil, repository'nin calisma sozlesmesini de tasimalidir.

## Interview Relevance

Bu konu "AI coding agent'lari buyuk bir codebase'e nasil guvenli entegre edersin?" sorusunda kullanilabilir. Guclu cevap; talimat dosyasi, dosya sahipligi, generated dosya sinirlari, targeted test komutlari, CI/flaky test ayrimi, audit edilebilir workflow ve human review noktalarini birlikte anlatir.

## Related Pages

- [Agent Workflow](agent-workflow.md)
- [LLM Wiki](llm-wiki.md)
- [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `vault://raw/repos/aspire-agents-md.md`

## Open Questions

- Lothal.KnowledgeWiki icin pattern-based instruction gerekli mi, yoksa mevcut dizin kurallari bir sure yeterli mi?
- Review prompt'u ileride generated wiki sayfalari icin otomatik kalite kapisi olarak standartlastirilmeli mi?
