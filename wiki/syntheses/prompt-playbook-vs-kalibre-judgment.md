# Prompt Playbook vs Kalibre Judgment

## Summary

Bu sentez, AI kullaniminda prompt playbook'larina yaslanmak ile kalibre judgment gelistirmek arasindaki farki inceler. Kaynagin ana fikri, iyi AI sonucunun sadece "dogru prompt" ile degil, model ciktisindan sonra yapilan degerlendirme ve kararlarla ortaya ciktigidir.

## Compared Ideas

- Prompt playbook: Hazir prompt koleksiyonlariyla daha iyi AI ciktisi alinabilecegi varsayimi.
- Kalibre judgment: Ciktiyi varsayim, risk, baglam, kanit ve uygulanabilirlik acisindan surekli degerlendirme becerisi.
- Agent workflow: LLM ciktisini talimatlar, review ve validation ile kontrollu bir surece yerlestirme.
- Knowledge wiki ingest: Ham kaynaktan kalici wiki sayfasi uretirken kaynak izlenebilirligi ve insan review'u koruma.

## Key Differences

Prompt playbook, giris tarafina odaklanir: AI'a hangi kelimelerle ne sorulacak? Bu faydali olabilir, ama karar kalitesini garanti etmez. Ayni prompt'u kullanan iki kisiden biri iyi sonuc alirken digeri yuzeysel veya hatali ciktinin pesinden gidebilir.

Kalibre judgment ise cikti sonrasi surece odaklanir: cevap hangi varsayimlari yapiyor, hangi alternatifleri disliyor, hangi riskleri gormuyor, hangi domain bilgisini eksik birakiyor? Bu beceri tekrar, domain bilgisi, karar sonuclarini izleme ve hatalardan ogrenme ile gelisir.

Prompt playbook bilgi transferi gibi gorunur; fakat cogunlukla sadece baskasinin ifade kalibini transfer eder. Kalibre judgment ise karar surecini daha acik, tekrar edilebilir ve denetlenebilir hale getirir.

## Practical Takeaways

- AI ciktisini ilk taslak veya aday cozum olarak kullan; final karar olarak degil.
- Hazir prompt kullanilsa bile ciktinin varsayimlarini mutlaka sorgula.
- "Bu en iyi cozum mu, yoksa internette en cok belgelenmis cozum mu?" sorusunu standart hale getir.
- Domain bilgisi olmadan yapilan suphecilik verimsizdir; once sistemin hedef davranisini netlestir.
- Review checklist'leri, validation scriptleri ve source reference disiplini judgment'i surece kodlar.
- Agent workflow'larinda insanin rolunu sadece prompt yazan kisi olarak degil, karar kalibrasyonu yapan operator olarak tasarla.

## When To Use Which

Prompt playbook su durumlarda faydali olabilir:

- Yeni bir problem alaninda baslangic sorulari bulmak.
- Tekrarlanan bir is icin standart prompt iskeleti olusturmak.
- Agent'a repo kurallarini veya beklenen cikti formatini hatirlatmak.

Kalibre judgment su durumlarda zorunludur:

- LLM ciktisi production kodu, mimari karar veya kalici dokumantasyon uretiyorsa.
- Cevap teknik olarak dogru gorunse de domain baglami eksik olabilirse.
- Model populer ama gereksiz karmasik bir yaklasim oneriyorsa.
- Sonuc commit, deploy, wiki ingest veya mulakat cevabi gibi kalici etki uretiyorsa.

## .NET / Backend Relevance

.NET backend projelerinde prompt playbook'lari kod taslagi, test fikri veya system design cercevesi uretmek icin kullanilabilir. Fakat final kalite, developer judgment'i ile gelir:

- EF Core sorgusu performansli mi, yoksa N+1 riskini mi sakliyor?
- Redis onerisi gercek bir cache ihtiyacini mi cozuluyor, yoksa source-of-truth problemini mi gizliyor?
- Microservice onerisi bagimsiz deploy ve ownership sagliyor mu, yoksa gereksiz dagitik karmasiklik mi uretiyor?
- Agent tarafindan uretilen wiki sayfasi kaynakla izlenebilir mi, yoksa guzel ama kaynaktan kopuk bir metin mi?

Bu nedenle Lothal.KnowledgeWiki'de prompt template'leri tek basina yeterli degildir. `AGENTS.md`, review prompt'u, `validate-wiki.ps1`, index/log disiplini ve insan denetimi birlikte calismalidir.

## Related Pages

- [AI Caginda Judgment](../concepts/ai-caginda-judgment.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Instructions](../concepts/agent-instructions.md)
- [Coding Agent vs Knowledge Wiki Agent](coding-agent-vs-knowledge-wiki-agent.md)
- [Cache vs Source of Truth](cache-vs-source-of-truth.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `raw/articles/2026-06-23-the-most-important-skill-in-the-age-of-ai-judgment.md`

## Open Questions

- Bu repo icin ingest review prompt'u judgment kalibrasyonunu daha acik olcmek icin hangi sorulari eklemeli?
- Prompt template'leri ile human review checklist'leri arasindaki sinir nasil korunmali?
