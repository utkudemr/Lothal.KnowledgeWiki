# Classic Agent vs Agent Harness

## Summary

Bu sentez, tek seferlik veya ince bir model etkileşimi ile modelin çevresine state, araç, doğrulama ve güvenlik mekanizmaları kuran agent harness yaklaşımını karşılaştırır. Ayrım mutlak bir ürün sınıflandırması değil, yürütme sorumluluğunun ne kadarının model çağrısı dışında açıkça yönetildiğini gösteren bir spektrumdur.

## Compared Ideas

- Classic/minimal etkileşim: kullanıcı girdisi model cevabına dönüşür; süreç kısa ve insan gözetimindedir.
- Tool-calling agent: model bir döngü içinde araç seçebilir fakat kalıcılık, recovery ve policy sınırlı olabilir.
- Agent harness: state, çalışma alanı, tool policy, validation, recovery, observability ve approval mekanizmalarını sistem katmanı olarak yönetir.
- Agent orchestration: harness içinde işin birden fazla agent arasında bölünmesini sağlayabilen, fakat zorunlu olmayan koordinasyon deseni.

## Key Differences

Minimal yaklaşım düşük kurulum ve koordinasyon maliyetiyle soru-cevap, kısa özet ve insanın hemen kontrol edeceği taslaklarda yeterlidir. Görev tamamlanmadan süreç kesilirse genellikle kullanıcı yeniden yönlendirir.

Harness yaklaşımı uzun veya yan etkili işlerde ilerlemeyi state olarak tutar, araç erişimini sınırlar, ara çıktıları kalıcılaştırır ve deterministik kabul kontrolleri çalıştırabilir. Buna karşılık execution state, permission, storage, retry, telemetry ve operasyon maliyeti getirir.

Kaynağın "classic agent stateless, toolsuz ve memory'sizdir" ifadesi yararlı bir karşılaştırma oluşturur fakat evrensel bir agent tanımı değildir. Bazı minimal agent framework'leri tool loop veya conversation state sunar. Daha doğru karar sorusu şudur: İşin ihtiyaç duyduğu yürütme garantileri açıkça hangi katman tarafından sağlanıyor?

## Practical Takeaways

- İki veya üç adımdan fazla olması tek başına harness gereksinimi değildir; süre, yan etki, recovery ve denetlenebilirlik ihtiyacını birlikte değerlendir.
- Salt metin üretiminde minimal kal; dosya, API veya production verisi değişiyorsa açık tool policy kur.
- Retry eklemeden önce işlemin idempotent olup olmadığını belirle.
- Modelin "başarılı" demesini kabul kriteri sayma; build, test, schema veya domain validation kullan.
- Memory ile run state'i ayır: biri gelecekteki oturumlara bilgi taşır, diğeri mevcut işin doğru devam etmesini sağlar.
- Subagent eklemeden önce görevin gerçekten bağımsız parçalara ayrılabildiğini ve aggregation sahibini belirle.
- İnsan onayını her adıma değil, geri döndürülemez veya yüksek etkili sınır işlemlerine yerleştir.

## When To Use Which

Minimal yaklaşımı tercih et:

- Tek cevap veya kısa taslak yeterliyse.
- Araç çağrısı ve kalıcı yan etki yoksa.
- Kullanıcı çıktıyı hemen inceleyip sonraki adımı kendisi seçecekse.
- Başarısızlık düşük maliyetliyse ve yeniden başlatmak kolaysa.

Harness tercih et:

- İş uzun sürüyor ve crash sonrası devam etmesi gerekiyorsa.
- Dosya, API, mesajlaşma veya veritabanı gibi dış sistemlerle etkileşiyorsa.
- Partial failure, retry ve duplicate yan etki yönetilecekse.
- Deterministik validation, audit ve gözlemlenebilirlik gerekiyorsa.
- Yetki sınırı, sandbox veya insan onayı gerekiyorsa.

## .NET / Backend Relevance

Bu seçim, tek bir controller içinde senkron iş yapmak ile durable bir workflow/background processing altyapısı kurmak arasındaki seçime benzer. Basit bir içerik taslağı doğrudan model çağrısıyla üretilebilir. Müşteriye mesaj gönderen, kayıt güncelleyen ve başka servislere event yayınlayan bir agent akışı ise kalıcı state, idempotency, outbox, retry policy, distributed tracing ve approval gerektirir.

Harness, model hatalarını ortadan kaldırmaz; onları backend mühendisliğinin bilinen failure model'leri içinde sınırlandırmaya yardımcı olur.

## Related Pages

- [Agent Harness](../concepts/agent-harness.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Orchestration](../concepts/agent-orchestration.md)
- [AI Caginda Judgment](../concepts/ai-caginda-judgment.md)
- [Single Agent vs Agent Orchestration](single-agent-vs-agent-orchestration.md)
- [Parallel Agent vs Flow Efficiency](parallel-agent-vs-flow-efficiency.md)
- [Agent harness nedir?](../interview/agent-harness-nedir.md)

## Source References

- `raw/tweets/2026-06-28-agent-harness-vs-classic-agent.md`
- `raw/tweets/2026-06-27-agent-orchestration-explained.md`

## Open Questions

- "Classic agent" terimi chat completion, tool-calling loop ve stateful assistant arasında ortak bir sınıflandırma sağlayabilir mi?
- Hangi risk eşiğinde hafif bir agent loop'undan durable harness'a geçilmeli?
- Harness yatırımı completion rate ve insan review süresinde ölçülebilir ne kadar iyileşme sağlamalı?
