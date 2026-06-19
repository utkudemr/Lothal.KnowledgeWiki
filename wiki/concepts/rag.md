# RAG

## Short Definition

RAG, yani Retrieval-Augmented Generation, modelin cevap üretmeden önce ilgili doküman parçalarını bulup bu parçaları cevap bağlamı olarak kullanmasıdır. RAG, raw kaynakların veya embedding'lenmiş belge parçalarının sorgu anında geri getirilmesine dayanır; bu bağlam genellikle kalıcı bir wiki ya da read model olarak saklanmaz.

## Why It Matters

RAG, LLM'in eğitim verisinde olmayan veya güncel olmayan bilgiyle çalışmasını sağlar. Ancak kaynaklar arasında uzun vadeli birikim, kalıcı sentez ve bakım otomatik olarak oluşmaz. Her yeni soru, ilgili parçaların tekrar bulunmasını ve yeniden birleştirilmesini gerektirir. Bu nedenle RAG genellikle bir bilgi projeksiyonu değil, bir retrieval katmanı olarak düşünülmelidir.

## Key Ideas

- Retrieval, cevap anında yapılır.
- Doküman parçaları genellikle chunk bazlı indekslenir.
- Sistem, iyi arama kalitesine ve iyi chunk stratejisine bağlıdır.
- Sentez çoğu zaman kalıcı bir artefakta dönüşmez.
- RAG ham kaynaklara yakın kalmak için güçlüdür, fakat bilgi tabanı bakımını tek başına çözmez.
- RAG, `raw/` veya embedding deposundan sorgu anında bilgi getirir; bu bilgi `wiki/` tipi bir projeksiyon değildir.

## Example

Bir takim, tum teknik dokumanlarini embedding indeksine koyup "outbox pattern nedir?" diye sordugunda sistem ilgili chunk'lari bulur ve cevap uretir. Bu cevap faydali olabilir, fakat cevap wikiye yazilmazsa sonraki soruda model ayni sentezi tekrar yapmak zorundadir.

## .NET / Backend Relevance

.NET backend sistemlerinde RAG, internal docs, runbook'lar, API sözleşmeleri, incident notları veya kod dokümantasyonu üzerinden soru cevaplamak için kullanılabilir. Azure AI Search, PostgreSQL vector extension, Elasticsearch veya benzeri altyapılarla uygulanabilir.

RAG genellikle raw kaynaklar ya da embedding depoları ile çalışır; buna karşın LLM Wiki bu raw kaynaklardan türetilmiş bir markdown read modelidir.

Backend tasarımında dikkat edilmesi gereken noktalar:

- Kaynak dokuman versiyonlama ve yetkilendirme.
- Chunk boyutu, metadata ve source citation kalitesi.
- Retrieval latency ve cache stratejisi.
- Hassas verinin indekslenmesi ve erisim kontrolu.
- Cevaplarin kalici bilgi tabanina donusup donusmeyecegi.

## Interview Relevance

RAG sorularinda sadece "dokuman arar ve cevap verir" demek zayif kalir. Daha guclu cevap; ingestion pipeline, chunking, embeddings, metadata filtering, reranking, citation, authorization ve evaluation konularini kapsar.

LLM Wiki ile fark sorulursa, RAG'in query-time retrieval yaptigi; LLM Wiki'nin ise ingest-time bilgi derlemesi ve markdown tabanli kalici sentez urettigi anlatilmali.

## Related Pages

- [LLM Wiki](llm-wiki.md)
- [Agent Workflow](agent-workflow.md)
- [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)

## Source References

- `raw/articles/karpathy-llm-wiki.md`

## Open Questions

- Bu wiki icin ileride basit markdown aramasi yeterli mi, yoksa qmd benzeri BM25/vector tabanli bir arac gerekli olacak mi?
- RAG ile LLM Wiki birlikte kullanıldığında, kaynak doğrulama ve kalıcı sentez arasındaki sınır nasıl tanımlanmalı?
- RAG çıktısı hangi koşullarda `wiki/` içine yeni bir sayfa veya güncelleme olarak kaydedilmeli?
