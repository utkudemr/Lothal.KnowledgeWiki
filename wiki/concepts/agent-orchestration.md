# Agent Orchestration

## Short Definition

Agent orchestration, karmaşık bir hedefi ana agent ile uzmanlaşmış subagent'lar arasında bölme; her subagent'a gerekli bağlamı verme; kısmi sonuçları birleştirme ve sonraki adımı seçme sürecidir.

## Why It Matters

Tek bir agent araştırma, kod analizi, güvenlik incelemesi ve raporlama gibi çok farklı sorumlulukları aynı context içinde taşıdığında dikkat dağılabilir ve context tüketimi artabilir. Orchestration, gerçekten bağımsız iş parçalarını daha küçük çalışma alanlarına ayırarak paralellik ve uzmanlaşma sağlar.

Bu kazanım ücretsiz değildir. Her subagent ek model çağrısı, token kullanımı, koordinasyon ihtiyacı ve çelişkili sonuçları çözme maliyeti getirir. Bu nedenle orchestration'ın amacı agent sayısını artırmak değil, bölünebilir bir problemi kontrollü bir fan-out/fan-in akışına dönüştürmektir.

Orchestration ile harness aynı şey değildir. Harness state, tool, validation, permission ve recovery dahil tüm execution sınırını kurar; orchestration ise bu sınır içinde işi birden fazla agent arasında bölmek için kullanılabilen opsiyonel bir desendir.

## Key Ideas

- Ana agent hedefi korur, işi böler, delegasyon sınırlarını belirler ve final cevabın sahipliğini taşır.
- Subagent, iyi tanımlanmış ve mümkün olduğunca bağımsız bir alt problemi çözer.
- Her subagent'a tüm geçmiş yerine görev, gerekli kanıt kaynakları, kısıtlar ve beklenen çıktı formatı verilmelidir.
- Kısmi sonuçlar bulgu, kanıt, risk, belirsizlik ve öneri gibi ortak bir sözleşmeyle dönmelidir.
- Ana agent sonuçları yalnızca yan yana eklemez; çelişkileri, boşlukları ve duplicate bulguları değerlendirir.
- Yeterli kanıt yoksa yeni araştırma turu başlatılır; yeterliyse final cevap üretilir.
- Basit veya sıkı bağlı işler için orchestration gereksiz maliyet yaratabilir.

## Example

Bir repository güvenlik incelemesinde ana agent işi üç bağımsız alana bölebilir:

1. Dependency agent'ı paket sürümlerini, bilinen CVE'leri ve obsolete kütüphaneleri inceler.
2. Code vulnerability agent'ı authorization, input validation, injection ve hassas veri akışlarını arar.
3. Configuration agent'ı secret, permission, security header ve CI/CD ayarlarını kontrol eder.

Her subagent dosya yolu ve somut kanıtla yapılandırılmış bulgular döndürür. Ana agent aynı kök nedenden gelen duplicate bulguları birleştirir, risk önceliği verir ve kapsam boşluğu varsa ek inceleme başlatır.

## .NET / Backend Relevance

Bu desen, .NET backend sistemlerindeki coordinator/worker ve fan-out/fan-in iş akışlarına benzer. Ana agent coordinator; subagent'lar worker; kısmi sonuçlar ise ortak response contract'ları gibi düşünülebilir.

Production seviyesinde bir agent workflow tasarlanırken backend'teki şu sorular da geçerlidir:

- Alt görev timeout veya cancellation aldığında ana akış ne yapacak?
- Aynı görev retry edilirse sonuç idempotent kalacak mı?
- Partial failure durumunda eksik sonuç açıkça raporlanacak mı?
- Trace/correlation ID ile hangi bulgunun hangi agent çalışmasından geldiği izlenebilecek mi?
- Paralellik rate limit, token bütçesi ve review kapasitesine göre sınırlandırılacak mı?

Claude Code, Codex veya Cursor gibi araçlardaki subagent kullanımı da bu zihinsel modelle değerlendirilebilir: görev gerçekten ayrık mı, bağlam sınırı açık mı ve final entegrasyonun tek sahibi var mı?

## Interview Relevance

Mülakatta güçlü bir cevap orchestration'ı yalnızca "birden fazla agent çalıştırmak" olarak tanımlamaz. Delegasyon, context seçimi, ortak çıktı sözleşmesi, result aggregation, next-step kararı ve maliyet trade-off'larını birlikte açıklar. Ayrıca basit veya yüksek derecede bağlı bir görevde tek agent'ın daha doğru seçim olabileceğini belirtir.

## Related Pages

- [Agent Harness](agent-harness.md)
- [Agent Workflow](agent-workflow.md)
- [Two-Track Agentic Development](two-track-agentic-development.md)
- [Single Agent vs Agent Orchestration](../syntheses/single-agent-vs-agent-orchestration.md)
- [Parallel Agent vs Flow Efficiency](../syntheses/parallel-agent-vs-flow-efficiency.md)
- [Agent orchestration nedir ve ne zaman kullanılmalıdır?](../interview/agent-orchestration-nedir-ve-ne-zaman-kullanilmalidir.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `raw/tweets/2026-06-27-agent-orchestration-explained.md`
- `raw/tweets/2026-06-28-agent-harness-vs-classic-agent.md`

## Open Questions

- Subagent sonuçları için repository genelinde kullanılabilecek en küçük ortak çıktı sözleşmesi ne olmalı?
- Token ve model çağrısı bütçesi hangi eşikte orchestration kararını değiştirmeli?
- Çelişen subagent bulgularında yeni bir doğrulama agent'ı mı, deterministik araç mı, yoksa insan review'u mu tercih edilmeli?
