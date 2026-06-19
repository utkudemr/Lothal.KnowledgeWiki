# LLM Wiki

## Short Definition

LLM Wiki, ham kaynaklar ile kullanicinin sorulari arasinda duran, LLM tarafindan surekli guncellenen kalici bir markdown bilgi katmanidir. LLM yeni kaynaklari sadece ileride aramak icin indekslemez; okur, ozetler, mevcut sayfalara entegre eder, ilgili baglantilari kurar ve celiskileri gorunur hale getirir.

## Why It Matters

Klasik dosya yukleme veya RAG deneyiminde model her soruda bilgiyi yeniden bulup birlestirmek zorundadir. LLM Wiki yaklasiminda sentez bir kez uretilir ve sonraki kaynaklarla buyur. Bu, ozellikle uzun vadeli ogrenme, teknik arastirma, is gorusmesi hazirligi ve proje dokumantasyonu icin degerlidir.

Bir muhendis acisindan asil fayda, bilginin sohbet gecmisinde kaybolmamasi ve her ingest sonrasi kalici bir artefakta donusmesidir. Sayfalar git ile izlenebilir, incelenebilir ve zaman icinde iyilestirilebilir.

## Key Ideas

- Ham kaynaklar degistirilmez; kaynak dogrulugu icin `raw/` altinda korunur.
- Wiki, LLM tarafindan uretilen ve bakimi yapilan islenmis bilgi katmanidir.
- `AGENTS.md` gibi bir sema dosyasi, ajana dizin yapisini, yazim kurallarini ve ingest akisini ogretir.
- Index, icerik odakli navigasyon saglar; log, kronolojik islem gecmisi saglar.
- Soru cevaplari, karsilastirmalar ve analizler de degerliyse wiki sayfasi olarak geri yazilabilir.

## Example

Bir .NET backend gelistirici, `raw/articles/` altina rate limiting ile ilgili bir makale ekler. LLM bu makaleyi okur, `wiki/concepts/sliding-window-rate-limit.md` sayfasini olusturur veya gunceller, ilgili interview notunu baglar, `wiki/index.md` dosyasina navigasyon ekler ve `wiki/log.md` dosyasina ingest kaydi yazar.

Sonraki hafta Redis tabanli dagitik rate limiting hakkinda baska bir kaynak eklendiginde LLM eski sayfayi bastan uretmez; mevcut sayfaya dagitik sistem notlarini ekler, varsa onceki iddialarla celiskileri `Open Questions` altinda belirtir.

## .NET / Backend Relevance

LLM Wiki, backend gelistirici icin teknik bilginin read model gibi duzenlenmesidir. Ham kaynaklar event log veya source of truth gibi dusunulebilir; wiki ise sorgulanabilir, optimize edilmis, insan tarafindan okunabilir bir projeksiyondur.

Bu yaklasim su konularda pratik deger uretir:

- ASP.NET Core, EF Core, MediatR, RabbitMQ, Redis veya PostgreSQL gibi teknolojiler icin tekrar kullanilabilir konsept notlari.
- Microservice, outbox/inbox, distributed lock ve observability gibi konular arasinda baglanti kurma.
- Is gorusmesi cevaplarini ham makalelerden turetilmis ama pratik deneyim diline cevrilmis sekilde saklama.
- Lothal.FlowRecovery veya Lothal.Mediator gibi projelerde mimari kararlarin kaynakli olarak gelismesi.

## Interview Relevance

Bu konu dogrudan bir interview sorusu olarak gelmeyebilir, fakat "RAG ile kalici bilgi tabani arasindaki fark nedir?", "LLM destekli dokumantasyon sistemini nasil tasarlarsin?" veya "teknik bilgi tabaninda kaynak guvenilirligini nasil korursun?" gibi sorulara guclu cevap zemini verir.

Guclu cevapta su ayrim vurgulanmali: RAG query-time retrieval yapar; LLM Wiki ise ingest-time sentez ve surekli bakim yapar. Ham kaynaklar immutable kalir, wiki turetilmis ve incelenebilir bir katmandir.

## Related Pages

- [RAG](rag.md)
- [Agent Workflow](agent-workflow.md)
- [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `raw/articles/karpathy-llm-wiki.md`

## Open Questions

- Orta olcekte `index.md` yeterli olsa da, wiki buyudugunde hangi noktada BM25, vector search veya hibrit arama aracina gecilmeli?
- LLM'in yanlis veya fazla iddiali sentez uretmesini azaltmak icin hangi review ve lint kurallari eklenmeli?
