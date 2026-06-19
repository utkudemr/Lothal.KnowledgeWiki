# RAG vs LLM Wiki

## Summary

RAG ve LLM Wiki, LLM'leri harici bilgiyle calistirmanin iki farkli yoludur. RAG genellikle soru aninda ilgili dokuman parcalarini bulup cevap uretir. LLM Wiki ise yeni kaynaklari ingest aninda isleyerek kalici, baglantili ve surumlenebilir bir markdown bilgi tabani olusturur.

## Compared Ideas

- [RAG](../concepts/rag.md): query-time retrieval ve cevap uretimi.
- [LLM Wiki](../concepts/llm-wiki.md): ingest-time sentez, kalici wiki ve surekli bakim.
- [Agent Workflow](../concepts/agent-workflow.md): bu surecleri kurallarla tekrarlanabilir hale getiren operasyon modeli.

## Key Differences

RAG'de bilgi genellikle ham dokuman chunk'larindan her soruda yeniden derlenir. LLM Wiki'de kaynak bir kez okunur, ana fikirler wikiye islenir ve sonraki kaynaklarla birlikte mevcut sentez guncellenir.

RAG daha cok arama ve cevaplama altyapisidir. LLM Wiki ise bilgi yonetimi, editoryal bakim ve ogrenme artefakti uretme yaklasimidir.

RAG'de en kritik kalite faktoru retrieval kalitesidir. LLM Wiki'de ise kaynak referansi, duplicate onleme, link kalitesi, celiski notlari, index ve log disiplini kritik hale gelir.

## Practical Takeaways

- Hizli soru cevap ve buyuk dokuman koleksiyonunda kaynak bulma gerekiyorsa RAG gucludur.
- Uzun vadeli teknik ogrenme, interview hazirligi ve proje bilgisi biriktirme gerekiyorsa LLM Wiki daha kalici deger uretir.
- Iki yaklasim rakip olmak zorunda degildir; buyuyen bir wiki ileride RAG veya markdown arama araci ile desteklenebilir.
- LLM Wiki, "cevap" yerine "bakimi yapilan bilgi tabani" uretmeye odaklanir.

## When To Use Which

RAG kullan:

- Cok sayida dokuman arasindan hizli arama ve kaynakli cevap gerekiyorsa.
- Bilgi sik degisiyor ve cevaplarin kalici sayfaya donusmesi gerekmiyorsa.
- Yetkilendirme, metadata filtering ve retrieval evaluation gibi production ihtiyaclari varsa.

LLM Wiki kullan:

- Kaynaklardan kalici teknik notlar, konsept sayfalari ve sentezler uretmek istiyorsan.
- Bir konuyu haftalar veya aylar boyunca derinlestiriyorsan.
- Interview hazirligi ve proje kararlari icin tekrar kullanilabilir bilgi istiyorsan.
- Insan tarafindan okunabilir, git ile izlenebilir markdown artefaktlari onemliyse.

## .NET / Backend Relevance

.NET backend acisindan RAG, teknik dokuman arama servisi gibi tasarlanabilir: ingestion pipeline, embedding store, metadata, authorization, API endpoint ve observability gerekir. LLM Wiki ise daha cok repository tabanli bir knowledge read model gibidir: ham kaynaklar degismez, wiki sayfalari turetilmis projeksiyon olarak guncellenir.

Bu repository icin pratik model sudur:

- `raw/` source of truth.
- `wiki/` LLM tarafindan bakimi yapilan bilgi read model.
- `AGENTS.md` workflow ve sema.
- `wiki/index.md` navigasyon.
- `wiki/log.md` audit trail.

## Related Pages

- [LLM Wiki](../concepts/llm-wiki.md)
- [RAG](../concepts/rag.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `raw/articles/karpathy-llm-wiki.md`

## Open Questions

- Bu repository belirli bir sayfa sayisina ulastiginda index tabanli navigasyon yeterli kalacak mi?
- Query cevaplarinin hangi kosullarda yeni wiki sayfasina donusturulecegi icin ayrica bir karar kurali yazilmali mi?
