# Agent orchestration nedir ve ne zaman kullanılmalıdır?

## Short Answer

Agent orchestration, karmaşık bir hedefi ana agent ve uzmanlaşmış subagent'lar arasında koordine etmektir. Ana agent neyin delege edileceğine, her subagent'ın hangi context'i alacağına, kısmi sonuçların nasıl birleştirileceğine ve sonraki adımın ne olduğuna karar verir. Bağımsız alt görevler olduğunda faydalıdır; basit veya sıkı bağlı görevlerde ek token ve koordinasyon maliyeti nedeniyle tek agent daha uygundur.

## Strong Answer

Orchestration sadece birden fazla agent'ı paralel çalıştırmak değildir. Dört temel karar içerir:

1. Görevi anlamlı ve mümkün olduğunca bağımsız alt problemlere bölmek.
2. Her subagent'a minimum yeterli context, kısıt ve beklenen çıktı formatını vermek.
3. Bulguları kanıt, risk, belirsizlik ve öneri üzerinden normalize edip birleştirmek.
4. Kapsam yeterliyse cevap vermek, boşluk veya çelişki varsa yeni inceleme başlatmak.

Kazancı daha küçük context'ler, uzmanlaşma ve paralelliktir. Maliyeti ise daha fazla model çağrısı, token, latency, handoff kaybı ve result aggregation karmaşıklığıdır. Bu yüzden seçim görev bağımsızlığına ve verification kapasitesine göre yapılmalıdır.

## Example From Experience

Bir .NET repository security review'unda ana agent dependency, application security ve configuration incelemelerini ayrı subagent'lara verebilir. Her biri dosya yolu, kanıt, severity ve remediation ile sonuç döndürür. Ana agent duplicate bulguları birleştirir, çelişkileri doğrular ve eksik kalan authentication veya CI/CD kapsamı için ek tur gerekip gerekmediğine karar verir.

Benzer şekilde KnowledgeWiki ingest akışında duplicate taraması ve teknik bağlantı analizi ayrık okuma görevleri olabilir. Ancak aynı wiki dosyalarını paralel agent'lara yazdırmak merge çatışması ve tutarsız anlatım üretebilir; final düzenleme ve validation tek sahipte kalmalıdır.

## Common Mistakes

- Orchestration'ı sadece "çok agent kullanmak" diye açıklamak.
- Birbirine sıkı bağlı görevleri yapay biçimde bölmek.
- Her subagent'a tüm konuşma geçmişini vererek context izolasyonunu boşa çıkarmak.
- Kanıt ve ortak çıktı formatı istemeden serbest metin sonuçları birleştirmeye çalışmak.
- Partial failure, timeout, retry ve çelişki yönetimini düşünmemek.
- Agent sayısını artırırken token bütçesi ve insan review bottleneck'ini göz ardı etmek.

## Related Concepts

- [Agent Orchestration](../concepts/agent-orchestration.md)
- [Single Agent vs Agent Orchestration](../syntheses/single-agent-vs-agent-orchestration.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Parallel Agent vs Flow Efficiency](../syntheses/parallel-agent-vs-flow-efficiency.md)

## Source References

- `vault://raw/tweets/2026-06-27-agent-orchestration-explained.md`
