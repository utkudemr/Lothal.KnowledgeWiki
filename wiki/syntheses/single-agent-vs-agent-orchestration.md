# Single Agent vs Agent Orchestration

## Summary

Bu sentez, bir hedefi tek agent ile uçtan uca çözmek ile işi ana agent ve subagent'lar arasında orkestre etmek arasındaki seçimi inceler. Temel karar problemi, ek paralellik ve küçük context'lerin koordinasyon maliyetine değip değmediğidir.

## Compared Ideas

- Tek agent: hedef, araştırma, araç kullanımı ve final sentez aynı context içinde yürütülür.
- Agent orchestration: ana agent işi böler, seçili context'i subagent'lara dağıtır ve sonuçları birleştirir.
- Flow efficiency: paralel agent sayısından önce gerçek bottleneck ve verification kapasitesi değerlendirilir.

## Key Differences

Tek agent yaklaşımı basit, sıralı veya birbirine sıkı bağlı görevlerde daha az koordinasyon ister. Bütün karar geçmişi aynı context'te bulunduğu için handoff kaybı düşüktür; fakat görev büyüdükçe sorumluluklar ve context tüketimi birikir.

Orchestration, dependency review ile configuration review gibi bağımsız alt görevlerde paralellik ve odak sağlar. Buna karşılık ana agent'ın doğru task boundary kurması, yeterli context vermesi, ortak çıktı formatı istemesi ve çelişkili sonuçları çözmesi gerekir. Kötü bölünmüş görevler hız yerine tekrar, token maliyeti ve entegrasyon borcu üretir.

## Practical Takeaways

- Önce görevin gerçekten bağımsız parçalara ayrılıp ayrılamadığını kontrol et.
- Tek agent'ın context veya sorumluluk sınırına yaklaşması tek başına yeterli değildir; subagent çıktılarının bağımsız üretilebilir olması gerekir.
- Delegasyonda amaç, kapsam ve beklenen çıktı sözleşmesini açık yaz.
- Subagent'a tüm context'i değil, doğru karar için gereken minimum yeterli context'i ver.
- Aggregation aşamasında kanıt, çelişki, eksik kapsam ve duplicate bulguları kontrol et.
- Paralellik kararını token bütçesi, rate limit ve insan review kapasitesiyle birlikte değerlendir.
- Deterministik build, test, lint ve validation işlerini sırf paralellik için agent'a dönüştürme.

## When To Use Which

Tek agent tercih edilebilir:

- Görev küçük veya büyük ölçüde sıralıdır.
- Alt adımlar aynı dosyalar ve kararlar üzerinde sıkı biçimde bağlıdır.
- Handoff ve aggregation maliyeti beklenen kazançtan yüksektir.
- Tek bir tutarlı yazım veya mimari karar sesi önemlidir.

Orchestration tercih edilebilir:

- Alt görevler açıkça ayrılabilir ve büyük ölçüde bağımsızdır.
- Farklı kaynak veya uzmanlık alanları paralel incelenebilir.
- Ana agent'ın sonuçları değerlendireceği net bir aggregation contract'ı vardır.
- Ek model çağrısı ve review maliyeti kabul edilebilir.

## .NET / Backend Relevance

Bir ASP.NET Core codebase incelemesinde tek agent küçük bir endpoint değişikliğini rahatça ele alabilir. Büyük bir production-readiness review ise API security, database migration, messaging reliability ve observability başlıklarına bölünebilir. Yine de final rapor tek bir coordinator tarafından severity, kanıt ve remediation önceliği açısından normalize edilmelidir.

Bu seçim microservice sınırı seçmeye benzer: yalnızca sistemi parçalara ayırmak değer üretmez. Sınırların cohesion ve coupling'e göre kurulması, contract'ların açık olması ve dağıtık koordinasyon maliyetinin kabul edilmesi gerekir.

## Related Pages

- [Agent Orchestration](../concepts/agent-orchestration.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Two-Track Agentic Development](../concepts/two-track-agentic-development.md)
- [Parallel Agent vs Flow Efficiency](parallel-agent-vs-flow-efficiency.md)
- [AI Caginda Judgment](../concepts/ai-caginda-judgment.md)

## Source References

- `raw/tweets/2026-06-27-agent-orchestration-explained.md`
- `raw/articles/2026-06-24-two-agent-workflow-for-agentic-development.md`

## Open Questions

- Bir alt görevin bağımsız sayılması için hangi coupling ölçütleri kullanılmalı?
- Orchestration başarısı latency, toplam token, bulgu kalitesi ve review süresiyle nasıl birlikte ölçülmeli?
