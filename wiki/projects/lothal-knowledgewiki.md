# Lothal KnowledgeWiki

## Purpose

Lothal KnowledgeWiki, .NET backend gelistirici icin teknik kaynaklari kalici, baglantili ve tekrar kullanilabilir markdown bilgi tabanina donusturen bir agent-assisted knowledge management reposudur.

Amac, makaleleri, tweet'leri, repo notlarini, video ozetlerini, is ilanlarini ve interview sorularini sadece arsivlemek degil; bunlardan pratik konsept sayfalari, sentezler, interview cevaplari ve proje notlari uretmektir.

## Current State

Repo, LLM Wiki desenini uygulayan basit ama genisleyebilir bir yapiya sahip:

- `raw/` altinda immutable kaynaklar tutulur.
- `wiki/` altinda islenmis bilgi sayfalari tutulur.
- `AGENTS.md`, ajanin nasil davranacagini ve hangi formatlari kullanacagini belirler.
- `wiki/index.md`, insan ve ajan icin navigasyon saglar.
- `wiki/log.md`, ingest ve buyuk guncellemeleri kronolojik olarak kaydeder.

## Important Concepts

- [LLM Wiki](../concepts/llm-wiki.md)
- [RAG](../concepts/rag.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Instructions](../concepts/agent-instructions.md)
- [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
- [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md)

## Architecture Notes

Bu repo, ham kaynak ile islenmis bilgi arasinda net bir ayrim kurar. `raw/` source of truth olarak kalir; LLM bu katmani degistirmez. `wiki/` ise kaynaklardan turetilen, linklenen ve zaman icinde guncellenen bilgi katmanidir.

Bu ayrim backend mimarisindeki event log ve read model ayrimina benzer. Ham kaynaklar audit edilebilir girdi, wiki sayfalari ise sorgulanabilir ve insan tarafindan tuketilebilir projeksiyondur.

## Agent Workflow Notes

Ingest akisi su sekilde islemelidir:

- Ajan once `AGENTS.md` dosyasini okur.
- Ilgili raw kaynak incelenir.
- Mevcut wiki sayfalari kontrol edilerek duplicate sayfa olusturulmaktan kacinilir.
- Gerekli konsept, synthesis, interview, project veya company sayfalari olusturulur ya da guncellenir.
- Sayfalar arasinda relative markdown linkleri kurulur.
- Kaynak referansi her sayfada korunur.
- `wiki/index.md` guncellenir.
- `wiki/log.md` dosyasina append-only kayit eklenir.

Aspire `AGENTS.md` ornegi, bu repoda talimatlarin daha da operasyonel hale getirilebilecegini gosterir. Sadece "Turkce yaz" veya "raw'a dokunma" gibi genel kurallar degil, hangi prompt'un ne zaman kullanilacagi, review'un hangi kalite kapilarini kontrol edecegi, source reference eksikliginin nasil ele alinacagi ve index/log tutarsizliklarinin nasil yakalanacagi da acik yazilabilir.

## Next Ideas

- Periyodik lint akisi tanimlamak: orphan sayfalar, eksik source reference, stale index entry ve eksik related page kontrolleri.
- Query sonucunda uretilen degerli cevaplarin hangi kosullarda wiki sayfasina donusecegini netlestirmek.
- Belirli sayfa sayisindan sonra markdown aramasi, BM25 veya qmd benzeri lokal arama araclarini degerlendirmek.
- Interview hazirligi icin konsept sayfalarindan cevap odakli interview sayfalari uretmek.
- `AGENTS.md` icinde review prompt'unun hangi durumlarda calistirilacagini ve hangi kalite kontrollerinin zorunlu oldugunu daha net yazmak.
- Aspire'daki pattern-based instruction fikrini bu repo icin sade bir sekilde uyarlamak: `raw/`, `wiki/concepts/`, `wiki/syntheses/`, `wiki/interview/` ve `wiki/projects/` icin ayrik beklentiler.

## Related Pages

- [LLM Wiki](../concepts/llm-wiki.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Instructions](../concepts/agent-instructions.md)
- [RAG vs LLM Wiki](../syntheses/rag-vs-llm-wiki.md)
- [Coding Agent vs Knowledge Wiki Agent](../syntheses/coding-agent-vs-knowledge-wiki-agent.md)

## Source References

- `raw/articles/karpathy-llm-wiki.md`
- `raw/repos/aspire-agents-md.md`
