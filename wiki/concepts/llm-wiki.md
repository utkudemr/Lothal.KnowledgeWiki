# LLM Wiki

## Short Definition

LLM Wiki, ham kaynaklardan (`raw/`) LLM tarafından türetilen ve sürekli güncellenen kalıcı bir markdown bilgi katmanıdır. `raw/` immutable kaynaklar olarak kalır; `wiki/` ise bu kaynakların işlenmiş read modeli, proje edilmiş bir rehberidir.

## Why It Matters

Klasik dosya yükleme veya RAG deneyiminde model her soruda bilgiyi yeniden bulup birleştirmek zorundadır. LLM Wiki yaklaşımında ise kaynaklar ingest anında işlenir; ana fikirler `wiki/` içinde kalıcı bir read model olarak birikir. Bu, özellikle uzun vadeli öğrenme, teknik araştırma, iş görüşmesi hazırlığı ve proje dokümantasyonu için değerlidir.

Bir mühendis açısından asıl fayda, bilginin sohbet geçmişinde kaybolmaması ve her ingest sonrası kalıcı bir artefaktın üretilmesidir. Sayfalar git ile izlenebilir, incelenebilir ve zaman içinde iyileştirilebilir.

`raw/` ham kaynak, `wiki/` ise LLM tarafından düzenlenmiş projeksiyon olduğunda, aynı kaynaktan sürekli yeniden çıkarım yapmak gerekmez.

## Key Ideas

- Ham kaynaklar değiştirilmeyen `raw/` altında tutulur.
- `wiki/`, bu ham kaynakların LLM tarafından işlenmiş, kalıcı ve bağlamlı bir projeksiyonudur.
- `AGENTS.md` gibi bir şema dosyası, ajana dizin yapısını, yazım kurallarını ve ingest akışını öğretir.
- Index, içerik odaklı navigasyon sağlar; log, kronolojik işlem geçmişini kaydeder.
- Soru cevapları, karşılaştırmalar ve analizler değerliyse wiki sayfası olarak geri yazılmalıdır.
- RAG query-time retrieval yaparken, LLM Wiki ingest-time sentez ve kalıcı bakım üretir.

## Example

Bir .NET backend geliştirici, `raw/articles/` altına rate limiting ve distributed cache ile ilgili bir makale ekler. LLM bu kaynağı okur, `wiki/concepts/sliding-window-rate-limit.md` sayfasını oluşturur veya günceller, ilgili interview notunu bağlar, `wiki/index.md` dosyasına navigasyon ekler ve `wiki/log.md` dosyasına ingest kaydı yazar.

Sonraki hafta Redis tabanlı dağıtık rate limiting hakkında başka bir kaynak eklendiğinde, LLM mevcut sayfayı tamamen yeniden üretmez; bunun yerine mevcut senteze yeni dağıtık sistem notları ekler ve önceki iddialarla çelişkiyi `Open Questions` altında belirtir.

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
