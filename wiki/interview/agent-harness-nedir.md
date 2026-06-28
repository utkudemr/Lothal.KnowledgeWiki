# Agent harness nedir ve production agent sisteminde neden gereklidir?

## Short Answer

Agent harness, dil modelinin çevresindeki yürütme ve kontrol katmanıdır. Modele plan, state, araç, çalışma alanı, retry, validation, observability, sandbox ve insan onayı gibi yetenekler kazandırır. Basit soru-cevapta gerekmeyebilir; uzun, yan etkili veya crash sonrası devam etmesi gereken işlerde model çağrısını production workflow'una dönüştürür.

## Strong Answer

Model bir reasoning engine olabilir ama tek başına güvenilir bir workflow runtime değildir. Harness şu ayrımı kurar:

- Model bir sonraki adımı veya içeriği önerir.
- Harness hangi araçların çağrılabileceğini ve hangi yetkiyle çalışacağını belirler.
- State/checkpoint katmanı işin nerede kaldığını saklar.
- Retry ve idempotency partial failure sonrası güvenli devamı sağlar.
- Deterministik test ve validation model çıktısını kontrol eder.
- Telemetry maliyet, latency, tool çağrısı ve hata nedenlerini görünür yapar.
- Sandbox ve human-in-the-loop yüksek riskli eylemleri sınırlar.

Harness kullanmak otomatik güvenilirlik sağlamaz. State, permission ve failure semantics kötü tasarlanırsa risk büyür. Bu nedenle production tasarımında model seçimi kadar execution boundary önemlidir.

## Example From Experience

Bir .NET coding agent'ın issue çözdüğünü düşünürüm. Agent repository'yi okur, patch üretir ve test çalıştırır. Dosya erişimi workspace ile sınırlanır; shell sandbox içinde çalışır; her tool çağrısı trace edilir; test başarısızsa state korunarak yeni deneme yapılır. Commit veya deploy gibi dış etkili adımlar insan onayı ister. Böylece model kod üretir, fakat workflow güvenliğini harness taşır.

## Common Mistakes

- Harness'ı yalnızca prompt template'i veya tool listesi sanmak.
- Her agent'ın stateless ve toolsuz olduğunu evrensel tanım gibi sunmak.
- Memory, conversation history ve durable run state'i aynı kavram saymak.
- Retry ekleyip idempotency ve duplicate yan etkiyi düşünmemek.
- Subagent sayısını artırmayı doğrudan güvenilirlik kabul etmek.
- Modelin kendi değerlendirmesini deterministik validation yerine kullanmak.
- Sandbox ile human approval'ın çözdüğü farklı riskleri karıştırmak.

## Related Concepts

- [Agent Harness](../concepts/agent-harness.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Orchestration](../concepts/agent-orchestration.md)
- [Classic Agent vs Agent Harness](../syntheses/classic-agent-vs-agent-harness.md)
- [Single Agent vs Agent Orchestration](../syntheses/single-agent-vs-agent-orchestration.md)

## Source References

- `vault://raw/tweets/2026-06-28-agent-harness-vs-classic-agent.md`
