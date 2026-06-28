# Two-Track Agentic Development

## Short Definition

Two-track agentic development, yazilim gelistirmede bir agent'i insanla birlikte specification/planlama uzerinde, diger agent'i ise hazir spec ve implementation plan uzerinden kod uretimi uzerinde calistiran iki hatli workflow'dur.

## Why It Matters

Agent sayisini artirmak tek basina throughput'u artirmaz. Yazilim gelistirmede specification, implementation ve verification farkli dikkat turleri ister. Agent'lar implementation tarafinda daha otonom calisabilir; fakat spec yazimi, karar verme, UX degerlendirmesi, code review ve functional testing hala insan judgment'i gerektirir.

Bu nedenle asil soru "kac agent calistirabilirim?" degil, "hangi asama bottleneck ve hangi asama insan dikkatini ne kadar istiyor?" sorusudur.

## Key Ideas

- Workflow iki hatta ayrilir: spec track ve implementation track.
- Spec track, feature fikrini PRD, functional specification, technical design ve implementation plan haline getirir.
- Implementation track, hazir spec ve plan uzerinden agent'in daha otonom kod yazmasini saglar.
- Spec uretimi genellikle ilk bottleneck'tir; tek insan ayni anda cok sayida kaliteli spec uretemez.
- Kodun bitmesi isin bitmesi degildir; review, functional testing, UX iyilestirme ve verification gerekir.
- Kanban'in "Stop starting, start finishing" fikri agent workflow'larinda da gecerlidir.
- Theory of Constraints ve queueing theory, agent sayisini degil bottleneck'i optimize etmeyi hatirlatir.

## Example

Solo bir backend gelistirici yeni bir admin panel ozelligi uzerinde calisiyor olsun. Ilk agent ile feature fikrini netlestirir: kullanici akisi, edge case'ler, yetkilendirme, veri modeli, API endpoint'leri ve kabul kriterleri sorulur. Bu calisma sonunda functional spec ve implementation plan olusur.

Sonra ikinci agent bu planla implementation'a baslar. Agent kod yazarken gelistirici bir sonraki feature icin spec track'e doner. Implementation bittiginde gelistirici review, test, UX ve domain davranisi kontrolu yapar. Bu dongu, on agent'i plansiz calistirmaktan daha kontrollu ve daha az yarim is ureten bir akistir.

## .NET / Backend Relevance

.NET backend icin bu workflow ozellikle API, background job, CQRS handler, MediatR pipeline, migration ve integration logic gibi islerde kullanislidir.

Spec track'te su artefact'lar uretilebilir:

- Endpoint davranisi ve authorization kurallari.
- Request/response contract'lari.
- Entity, migration ve transaction sinirlari.
- Outbox/inbox, retry, idempotency ve observability kararlari.
- Test senaryolari ve acceptance criteria.

Implementation track'te agent bu plan uzerinden controller, handler, validator, migration, integration test veya docs degisikliklerini yapabilir. Fakat merge karari yine review, test ve domain judgment ile verilmelidir.

Lothal.KnowledgeWiki icin benzer model vardir: raw source ve context spec input gibidir; ingest agent implementation benzeri bilgi uretir; review prompt ve `validate-wiki.ps1` verification hattini temsil eder.

## Interview Relevance

Bu konu "AI agent'lari yazilim gelistirme workflow'una nasil dahil edersin?" sorusunda guclu bir cevap verir. Iyi cevap, cok agent calistirmaktan once bottleneck'i, spec kalitesini, review ihtiyacini ve verification gate'lerini anlatir.

Kisa mulakat cevabi: Agent'lari paralel calistiririm ama her isi ayni anda baslatmam. Once spec ve plan kalitesini yukseltirim, sonra implementation agent'ini daha otonom calistiririm. Kod bittiginde review, test ve UX/domain kontrolu yapmadan tamamlanmis saymam.

## Related Pages

- [Agent Workflow](agent-workflow.md)
- [AI Caginda Judgment](ai-caginda-judgment.md)
- [Parallel Agent vs Flow Efficiency](../syntheses/parallel-agent-vs-flow-efficiency.md)
- [Prompt Playbook vs Kalibre Judgment](../syntheses/prompt-playbook-vs-kalibre-judgment.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `vault://raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`

## Open Questions

- Iki-track modelinde spec artefact'lari ne kadar detayli olmali ki agent otonom calisabilsin ama plan yazimi yeni bottleneck'e donusmesin?
- Backend-only islerde iki agent yerine spec/review checklist'i ile tek agent yeterli olabilir mi?
- Bu workflow'u Lothal.KnowledgeWiki ingest/review akisi icin `.agent/runs/` artefact'lariyla nasil daha izlenebilir hale getirmek gerekir?
