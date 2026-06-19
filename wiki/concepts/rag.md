# RAG

## Short Definition

RAG, yani Retrieval-Augmented Generation, modelin cevap uretmeden once ilgili dokuman parcalarini bulup bu parcalari cevap baglami olarak kullanmasidir. Bilgi genellikle sorgu aninda geri getirilir ve cevap icin yeniden sentezlenir.

## Why It Matters

RAG, LLM'in egitim verisinde olmayan veya guncel olmayan bilgiyle calismasini saglar. Ancak kaynaklar arasinda uzun vadeli birikim, kalici sentez ve bakim otomatik olarak olusmaz. Her yeni soru, ilgili parcalarin tekrar bulunmasini ve yeniden birlestirilmesini gerektirir.

## Key Ideas

- Retrieval, cevap aninda yapilir.
- Dokuman parcalari genellikle chunk bazli indekslenir.
- Sistem, iyi arama kalitesine ve iyi chunk stratejisine baglidir.
- Sentez cogu zaman kalici bir artefakta donusmez.
- RAG ham kaynaklara yakin kalmak icin gucludur, fakat bilgi tabani bakimini tek basina cozmez.

## Example

Bir takim, tum teknik dokumanlarini embedding indeksine koyup "outbox pattern nedir?" diye sordugunda sistem ilgili chunk'lari bulur ve cevap uretir. Bu cevap faydali olabilir, fakat cevap wikiye yazilmazsa sonraki soruda model ayni sentezi tekrar yapmak zorundadir.

## .NET / Backend Relevance

.NET backend sistemlerinde RAG, internal docs, runbook'lar, API sozlesmeleri, incident notlari veya kod dokumantasyonu uzerinden soru cevaplamak icin kullanilabilir. Azure AI Search, PostgreSQL vector extension, Elasticsearch veya benzeri altyapilarla uygulanabilir.

Backend tasariminda dikkat edilmesi gereken noktalar:

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
- RAG ile LLM Wiki birlikte kullanildiginda, kaynak dogrulama ve kalici sentez arasindaki sinir nasil tanimlanmali?
