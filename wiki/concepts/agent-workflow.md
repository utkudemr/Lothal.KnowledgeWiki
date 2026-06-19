# Agent Workflow

## Short Definition

Agent workflow, bir LLM ajaninin belirli talimatlar, dosya yapisi, araclar ve kalite kurallariyla tekrarlanabilir isler yapmasidir. Bu repoda agent workflow, ham kaynaklari okuyup wiki sayfalarina donusturen disiplinli ingest, query, lint ve loglama surecidir.

## Why It Matters

LLM'i sadece sohbet araci olarak kullanmak bilgi birikimini daginik birakabilir. Agent workflow ise ayni isi tekrar tekrar tutarli sekilde yapmayi saglar: kaynak oku, ilgili sayfalari bul, gerekiyorsa olustur, baglantilari kur, index'i guncelle, log'a yaz.

Bu, bilgi yonetimini yazilim gelistirme is akisi gibi ele alir. Kurallar repo icinde oldugu icin workflow incelenebilir, degistirilebilir ve surumlenebilir.

## Key Ideas

- Ajanin davranisi `AGENTS.md` gibi bir talimat dosyasiyla sinirlandirilir.
- Ham kaynaklar immutable tutulur; ajan sadece `wiki/` altindaki islenmis bilgiyi gunceller.
- Ingest, query ve lint farkli operasyonlar olarak dusunulur.
- Her anlamli degisiklik index ve log ile izlenebilir hale gelir.
- Insan kaynak secer, oncelik verir ve kaliteyi denetler; ajan operasyonel bakimi yapar.
- Buyuk repository'lerde agent workflow, genel talimatlarin yaninda dosya sahipligi, generated dosya sinirlari, test komutlari ve kalite kapilariyla desteklenmelidir.

## Example

Bu repoda yeni bir makale eklendiginde ajan once `AGENTS.md` dosyasini okur, sonra kaynak dosyayi inceler, mevcut wiki sayfalarini kontrol eder, duplicate olusturmadan ilgili konsept ve sentez sayfalarini gunceller. Is bitince `wiki/index.md` ve `wiki/log.md` dosyalarini da gunceller.

## .NET / Backend Relevance

Agent workflow, backend muhendisligindeki pipeline ve background job mantigina benzer. Bir ingest operasyonu, kabaca su adimlara ayrilabilir:

- Input: `raw/` altindaki kaynak.
- Processing: ozetleme, kavram cikarma, celiski tespiti, linkleme.
- Output: `wiki/` altinda markdown sayfalari.
- Audit: index ve log guncellemesi.

Bu zihinsel model, agent tabanli araclari .NET projelerine entegre ederken de kullanilabilir. Ornegin bir ASP.NET Core servisinde agent workflow; issue analizi, kod inceleme notu, runbook guncelleme veya incident postmortem taslagi uretmek icin ayrik adimlara bolunebilir.

Aspire ornegi, .NET repository'lerinde agent workflow'un restore/build/test komutlari, Microsoft.Testing.Platform filtreleri, quarantined/outerloop test ayrimi, generated API dosyalari ve NuGet feed kurallari gibi somut maintainer bilgisini de tasimasi gerektigini gosterir.

## Interview Relevance

Agent workflow konusu, "LLM'i production sureclerine nasil kontrollu eklersin?" sorusuna cevap verirken kullanilabilir. Guclu cevap; serbest sohbet yerine talimat dosyasi, kaynak sinirlari, audit log, human review ve tekrar edilebilir operasyonlardan bahseder.

## Related Pages

- [Agent Instructions](agent-instructions.md)
- [LLM Wiki](llm-wiki.md)
- [RAG](rag.md)
- [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
- [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `raw/articles/karpathy-llm-wiki.md`
- `raw/repos/aspire-agents-md.md`

## Open Questions

- Bu repoda periyodik lint operasyonu icin hangi kontroller standart hale getirilmeli?
- Agent workflow ileride otomatik komutlarla desteklenecekse, hangi adimlar script veya CLI aracina tasinmali?
- Lothal.KnowledgeWiki'de review ve lint adimlari Aspire'daki test/CI kalite kapilarina benzer sekilde zorunlu hale getirilmeli mi?
