# Coding Agent vs Knowledge Wiki Agent

## Summary

Coding agent ve knowledge/wiki agent ayni LLM tabanli arac ailesine ait olabilir, fakat amaclari ve risk yuzeyleri farklidir. Coding agent, calisan kod uzerinde degisiklik yapar ve build/test kalitesiyle dogrulanir. Knowledge wiki agent ise ham kaynaklari isleyerek kalici markdown bilgi katmani uretir ve kaynak izlenebilirligi, link kalitesi, duplicate onleme ve ogrenme degeriyle dogrulanir.

Microsoft Aspire `AGENTS.md` dosyasi, buyuk bir .NET repository'de coding agent'a verilecek operasyonel sinirlari gosterir. Lothal.KnowledgeWiki'nin `AGENTS.md` dosyasi ise bilgi yonetimi ve ingest sureci icin benzer bir disiplin kurar.

## Compared Ideas

- [Agent Instructions](../concepts/agent-instructions.md): Ajanlara repository davranis kurallarini anlatan talimat katmani.
- [Agent Workflow](../concepts/agent-workflow.md): Talimatlar, dosya yapisi ve kalite kurallariyla tekrar edilebilir ajan operasyonu.
- Coding agent: Kod degisikligi, test, build, review ve maintainer convention'lariyla calisan ajan.
- Knowledge/wiki agent: external `KnowledgeMemory/raw/` kaynaklardan `wiki/` sayfalari ureten, index/log ve `vault://raw/...` kaynak referansi disipliniyle calisan ajan.

## Key Differences

Coding agent icin ana risk, repository'yi calismaz hale getirmek veya takim convention'larini bozmak olabilir. Bu nedenle Aspire talimatlari generated API dosyalarina dokunmama, `global.json` ve NuGet config gibi kritik dosyalari koruma, restore/build sirasi, test filtreleri, flaky/outerloop ayrimi ve localization gibi pratik sinirlari ayrintili yazar.

Knowledge/wiki agent icin ana risk, bilginin kaynaktan kopmasi, duplicate sayfalar uretilmesi, hatali sentezlerin kalici hale gelmesi veya index/log disiplininin bozulmasidir. Bu nedenle external `KnowledgeMemory/raw/` immutable tutulur, `wiki/` turetilmis read model olarak guncellenir, her sayfada source reference korunur ve her ingest loglanir.

Coding agent'in kalite kapilari daha cok derleme, test, API uyumlulugu ve CI davranisidir. Knowledge/wiki agent'in kalite kapilari ise kaynak izlenebilirligi, linkleme, acik sorular, interview/project baglantisi ve insan tarafindan okunabilirliktir.

## Practical Takeaways

- Agent talimatlari repo turune gore yazilmalidir; coding repo ile knowledge repo ayni prompt semasini kullanmamalidir.
- Buyuk .NET codebase'lerde "hangi komut calisir?" kadar "hangi komut risklidir?" bilgisi de yazilmalidir.
- Knowledge wiki icin en kritik kural, ham kaynagi degistirmeden islenmis bilgi katmanini guncellemektir.
- Aspire'dan alinabilecek iyi pratik, talimatlari genel niyetlerden somut operasyon kurallarina indirmektir.
- Lothal.KnowledgeWiki icin iyi bir sonraki adim, review/lint kalite kapilarini AGENTS.md icinde daha operasyonel hale getirmektir.

Lothal.KnowledgeWiki icin pratik karsilik sudur: coding agent tarafindaki `restore/build/test` kalite kapilari burada `source reference/index/log/link/review` kalite kapilarina donusur. Ajan bir wiki sayfasi urettiginde yalnizca metnin iyi gorunmesi yetmez; sayfanin hangi raw kaynaktan turetildigi, hangi mevcut sayfalarla iliskili oldugu, index'te bulunup bulunmadigi ve log'da izlenip izlenmedigi de dogrulanmalidir.

## When To Use Which

Coding agent talimatlarini guclendir:

- Repository'de build/test komutlari proje ozeliyse.
- Generated dosyalar, public API baseline'lari veya lock/config dosyalari varsa.
- CI, flaky test, outerloop test veya internal feed gibi maintainer bilgisi gerekiyorsa.
- PR review kalitesi ve degisiklik guvenligi onemliyse.

Knowledge/wiki agent talimatlarini guclendir:

- Ham kaynaklardan kalici ogrenme artefaktlari uretiliyorsa.
- Index, log, source reference ve related page disiplini gerekiyorsa.
- Interview hazirligi, proje notlari ve teknik sentezler ayni repo icinde buyuyorsa.
- Insan review'u commit oncesi kalite kapisi olarak kullaniliyorsa.

Bu sistemde bilgi agent'i icin en iyi sinir sudur: external `KnowledgeMemory/raw/` kaynak arsividir, public `wiki/` ise turetilmis read modeldir. Ajan kaynak dosyayi yeniden yazmaz; kaynakla izlenebilir, Turkce, linkli ve review edilebilir bir bilgi katmani uretir.

## .NET / Backend Relevance

.NET backend muhendisi icin bu ayrim production sistemlerdeki command side ve read model ayrimina benzer. Coding agent command side'a daha yakindir: gercek sistemi degistirir, bu yuzden test ve CI ile dogrulanir. Knowledge/wiki agent read model bakimina daha yakindir: ham kaynaklardan insanin okuyacagi projeksiyonlar uretir, bu yuzden traceability ve review ile dogrulanir.

Aspire ornegi, buyuk .NET repository'lerinde agent'a verilen talimatin restore, build, test runner, NuGet feed, generated API ve localization gibi operasyonel detaylari kapsamasi gerektigini gosterir. Lothal.KnowledgeWiki icin ayni olgunluk; raw immutability, source reference, log, index, duplicate handling ve review prompt disiplini olarak karsilik bulur.

## Related Pages

- [Agent Instructions](../concepts/agent-instructions.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [LLM Wiki](../concepts/llm-wiki.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `vault://raw/repos/aspire-agents-md.md`

## Open Questions

- Lothal.KnowledgeWiki'de review prompt'u her ingest sonrasi zorunlu kalite kapisi olmali mi, yoksa kullanici kararina mi birakilmali?
- Coding agent talimatlarindan hangi bolumler bu bilgi reposuna dogrudan tasinmali, hangileri sadece ilham olarak kalmali?
