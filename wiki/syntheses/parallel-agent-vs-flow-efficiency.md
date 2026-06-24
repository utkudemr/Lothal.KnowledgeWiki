# Parallel Agent vs Flow Efficiency

## Summary

Bu sentez, "daha cok agent calistirmak" fikri ile "sistemin asil bottleneck'ini optimize etmek" fikrini karsilastirir. Kaynagin ana iddiasi, agentic development'ta throughput'un agent sayisindan cok specification, review ve verification kapasitesiyle sinirlandigidir.

## Compared Ideas

- Cok sayida implementation agent'ini paralel calistirma.
- Iki-track agentic workflow: spec track ve implementation track.
- Kanban, Theory of Constraints ve queueing theory ile flow efficiency bakisi.
- Human judgment gerektiren review, testing ve UX/domain verification adimlari.

## Key Differences

Cok agent yaklasimi, implementation kapasitesini artirmaya odaklanir. Bu, yalnizca implementation gercek bottleneck ise ise yarar. Fakat kaynak, agentic development'ta bottleneck'in cogu zaman spec uretimi ve verification oldugunu savunur.

Flow efficiency yaklasimi ise sisteme butun olarak bakar. Spec hazir degilse implementation agent'i bekler. Implementation bitince review ve test kapasitesi yoksa is yarim kalir. Bu nedenle paralellik, sadece insan dikkatini daha iyi kullanacak sekilde tasarlandiginda deger uretir.

## Practical Takeaways

- Agent sayisini degil, akisin bottleneck'ini optimize et.
- Implementation'a baslamadan once spec, technical design ve task breakdown uret.
- Agent'in otonom calismasini input artefact kalitesiyle sagla.
- Ayni anda cok sayida spec baslatmak yerine bir spec'i bitirip implementation'a tasimak daha saglikli olabilir.
- Kod uretimini tamamlanmis is sayma; review, functional testing ve UX/domain verification ayri kalite kapilaridir.
- Throwaway prototype icin daha serbest "vibe coding" kabul edilebilir; uzun omurlu kod icin spec ve review maliyeti kendini geri oder.

## When To Use Which

Cok agent paralelligi su durumlarda daha anlamli olabilir:

- Isler birbirinden bagimsizdir.
- Spec'ler zaten hazirdir.
- Review ve test kapasitesi yeterlidir.
- Cikti throwaway veya dusuk risklidir.

Iki-track workflow su durumlarda daha uygundur:

- Solo developer, technical founder veya builder hem product hem code kararini tasiyordur.
- Feature uzun omurlu production koduna gidecektir.
- Spec, architecture ve review kalitesi urun kalitesini dogrudan etkiliyordur.
- Implementation agent'i calisirken insan yeni spec uzerinde dusunerek paralel dikkat kullanabilir.

## .NET / Backend Relevance

.NET backend projelerinde "daha cok agent" cazip gorunebilir: biri API yazsin, biri migration yazsin, biri test yazsin. Fakat domain davranisi, transaction sinirlari, idempotency, authorization, observability ve veri tutarliligi net degilse paralel kod uretimi daha cok review borcu yaratir.

Daha iyi yaklasim, once technical design ve implementation plan uretmektir. Ornegin bir siparis workflow'u icin once aggregate davranisi, event/outbox karari, retry politikasi ve integration contract'lari netlestirilir. Sonra agent implementation'a gecerse review daha hedefli olur.

## Related Pages

- [Two-Track Agentic Development](../concepts/two-track-agentic-development.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [AI Caginda Judgment](../concepts/ai-caginda-judgment.md)
- [Prompt Playbook vs Kalibre Judgment](prompt-playbook-vs-kalibre-judgment.md)
- [Coding Agent vs Knowledge Wiki Agent](coding-agent-vs-knowledge-wiki-agent.md)

## Source References

- `raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`

## Open Questions

- Agentic development icin ideal WIP limit nasil belirlenmeli?
- Hangi feature turlerinde spec track hafif tutulabilir, hangi durumlarda ayrintili PRD ve technical design gerekir?
- Verification bottleneck'ini azaltmak icin otomatik test, preview environment ve checklist'ler nasil birlikte kullanilmali?
