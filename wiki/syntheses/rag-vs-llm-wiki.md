# RAG vs LLM Wiki

## Summary

RAG ve LLM Wiki, LLM'leri harici bilgiyle çalıştırmanın iki farklı yoludur. RAG genellikle soru anında ilgili doküman parçalarını bulup cevap üretir. LLM Wiki ise yeni kaynakları ingest anında işleyerek kalıcı, bağlantılı ve sürümlenebilir bir markdown bilgi tabanı oluşturur.

Bu repo bağlamında `raw/` ham kaynağın, `wiki/` ise LLM tarafından üretilmiş read modelin karşılığıdır.

## Compared Ideas

- [RAG](../concepts/rag.md): query-time retrieval ve cevap uretimi.
- [LLM Wiki](../concepts/llm-wiki.md): ingest-time sentez, kalici wiki ve surekli bakim.
- [Agent Workflow](../concepts/agent-workflow.md): bu surecleri kurallarla tekrarlanabilir hale getiren operasyon modeli.

## Key Differences

RAG'de bilgi genellikle ham doküman chunk'larından her soruda yeniden derlenir. LLM Wiki'de kaynak bir kez okunur, ana fikirler wikiye işlenir ve sonraki kaynaklarla birlikte mevcut sentez güncellenir.

RAG daha çok arama ve cevaplama altyapısıdır. LLM Wiki ise daha çok bilgi yönetimi, editoryal bakım ve öğrenme artefaktı üretme yaklaşımıdır.

- Raw kaynak: `raw/` üzerinde immutable kaynaklar.
- LLM Wiki: `wiki/` üzerinde işlenmiş markdown projeksiyonu.
- RAG: runtime'da retrieval yapan destekleyici arama katmanı.

RAG'de en kritik kalite faktoru retrieval kalitesidir. LLM Wiki'de ise kaynak referansi, duplicate onleme, link kalitesi, celiski notlari, index ve log disiplini kritik hale gelir.

## Practical Takeaways

- Hızlı soru cevap ve büyük doküman koleksiyonunda kaynak bulma gerekiyorsa RAG güçlüdür.
- Uzun vadeli teknik öğrenme, interview hazırlığı ve proje bilgisi biriktirme gerekiyorsa LLM Wiki daha kalıcı değer üretir.
- İki yaklaşım rakip olmak zorunda değildir; büyüyen bir wiki ileride RAG veya markdown arama aracı ile desteklenebilir.
- Bu repo bağlamında, `raw/` ham kaynak, `wiki/` ise LLM tarafından bakımı yapılan bilgi read modelidir.
- LLM Wiki, yalnızca cevap üretmek yerine sürekli bakımı yapılan, gözden geçirilebilen bilgi tabanı üretmeye odaklanır.

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
