# Agentic development'ta neden cok agent her zaman verimli degildir?

## Short Answer

Cunku yazilim gelistirme sadece implementation kapasitesinden olusmaz. Specification, review, testing, UX/domain verification ve final karar hala insan dikkatine baglidir. Daha cok agent, eger bottleneck implementation degilse sadece daha cok yarim is ve review borcu uretir.

## Strong Answer

Agentic development'ta paralellik degerli olabilir, ama sistemin throughput'u en yavas asama ile sinirlidir. Bir feature icin iyi bir spec, technical design ve implementation plan yoksa agent'in hizli kod yazmasi cok anlamli degildir. Kod bittikten sonra da is bitmez; code review, functional testing, edge case kontrolu, UX ve domain dogrulama gerekir.

Bu yuzden ben cok agent'i ayni anda rastgele calistirmak yerine iki-track bir workflow tercih ederim. Spec track'te agent ile birlikte feature fikrini netlestirir, PRD/functional spec, technical design ve task breakdown uretirim. Implementation track'te baska bir agent bu input'larla daha otonom calisir. O implementation surerken ben bir sonraki spec uzerinde calisabilirim. Boylece paralellik, insan dikkatini dagitmak yerine flow'u destekler.

## Example From Experience

Bir ASP.NET Core admin ozelligi dusunelim. Agent'a sadece "sponsorluk yonetimi ekle" demek yerine once spec hazirlarim: roller, validasyonlar, veri modeli, endpoint davranisi, transaction siniri, audit log ve acceptance criteria. Sonra implementation agent'i bu plana gore controller, service, migration ve testleri uretir.

Agent kod yazarken ben bir sonraki feature'in spec'ini hazirlayabilirim. Ama implementation bittiginde yine diff'i incelerim, testleri calistiririm, authorization ve domain edge case'lerini kontrol ederim. Bu, on agent'in plansiz sekilde kod uretmesinden daha az gosterisli ama daha guvenilir bir workflow'dur.

## Common Mistakes

- Agent sayisini dogrudan productivity ile esitlemek.
- Spec kalitesini atlayip implementation hizina odaklanmak.
- Kod uretilince isin bittigini sanmak.
- Review ve functional testing kapasitesini hesaba katmamak.
- UX veya product judgment'i tamamen agent'a devretmek.
- Throwaway prototype ile production kodunu ayni workflow'a sokmak.

## Related Concepts

- [Two-Track Agentic Development](../concepts/two-track-agentic-development.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [AI Caginda Judgment](../concepts/ai-caginda-judgment.md)
- [Parallel Agent vs Flow Efficiency](../syntheses/parallel-agent-vs-flow-efficiency.md)

## Source References

- `raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`
