# Agent Harness

## Short Definition

Agent harness, bir dil modelini uzun süren ve araç kullanan işleri yürütebilen bir sisteme dönüştüren çalışma zamanı ve kontrol katmanıdır. Planlama, durum yönetimi, araç erişimi, çalışma alanı, retry, doğrulama, gözlemlenebilirlik, yetkilendirme ve insan onayı gibi sorumlulukları model çağrısının çevresinde toplar.

## Why It Matters

Model tek başına bir sonraki çıktıyı üretir; çok adımlı bir işin nerede kaldığını, hangi yan etkinin gerçekleştiğini veya başarısız bir adımdan nasıl devam edileceğini güvenilir biçimde yönetmez. Harness bu operasyonel sorumlulukları açık hale getirir.

Harness kullanmak sistemi otomatik olarak güvenilir yapmaz. State yanlış modellenirse, araçlar fazla yetkiliyse veya retry edilen işlemler idempotent değilse daha otonom fakat daha riskli bir sistem oluşur. Asıl değer, model muhakemesi ile deterministik yürütme ve güvenlik politikalarını birbirinden ayırabilmektir.

## Key Ideas

- Model muhakeme üretir; harness yürütme döngüsünü ve sınırlarını yönetir.
- Plan ve checkpoint, uzun işlerin ilerlemesini görünür ve devam ettirilebilir yapar.
- Dosya veya benzeri çalışma alanları büyük ara çıktıları prompt dışına taşıyabilir.
- Kısa süreli state mevcut işi, kalıcı memory ise oturumlar arası bilgiyi taşır; ikisi aynı şey değildir.
- Tool katmanı dosya, API, veritabanı veya komut çalıştırma gibi yan etkileri kontrollü sözleşmelerle açar.
- Subagent ve orchestration harness'ın olası yetenekleridir; her harness çok agent kullanmak zorunda değildir.
- Sandbox erişim sınırı sağlar; human-in-the-loop yüksek etkili işlemlerde karar kapısı kurar.
- Test, validation, audit log, timeout, retry ve telemetry production güvenilirliğinin model dışındaki parçalarıdır.
- Harness tek bir ürün değil, hafif bir tool-calling loop'tan durable workflow runtime'ına uzanan bir tasarım spektrumudur.

## Example

Bir coding agent bug düzeltirken repository dosyalarını okur, değişiklik yapar, testleri çalıştırır ve sonucu değerlendirir. Harness:

1. Hedefi ve izin verilen dosya sınırını kaydeder.
2. Araştırma ve uygulama adımlarını takip eder.
3. Dosya ve shell araçlarını sandbox içinde sunar.
4. Test başarısızsa çıktıyı yeni adıma girdi yapar.
5. Hassas veya geri döndürülemez işlemden önce insan onayı ister.
6. Denemeleri, tool çağrılarını ve final validation sonucunu audit için saklar.

Bu döngüde kod önerisini model üretir; yetki, state geçişi, retry ve kabul koşullarını harness yönetir.

## .NET / Backend Relevance

Agent harness, .NET backend'deki application service, workflow engine ve background job altyapısının birleşimine benzer. Bir ASP.NET Core sisteminde model çağrısı yalnızca karar üreten dependency olabilir; orchestration katmanı ise şu sorumlulukları taşımalıdır:

- İş durumunu MSSQL veya PostgreSQL'de kalıcılaştırmak.
- Tool çağrılarına timeout, cancellation ve authorization uygulamak.
- Retry edilen yan etkiler için idempotency key ve outbox/inbox kullanmak.
- Her adıma correlation ID, structured log, metric ve trace eklemek.
- Uzun işlemleri request lifecycle yerine durable background worker'da yürütmek.
- Production verisi yazma, mesaj gönderme veya deploy gibi işlemlere approval gate koymak.

Bir harness tasarlanırken model provider değişiminden çok execution semantics önemlidir: crash sonrası devam, duplicate yan etkiyi önleme, partial failure görünürlüğü ve maliyet sınırı.

## Interview Relevance

Mülakatta agent harness yalnızca "LLM'e tool eklemek" diye açıklanmamalıdır. Güçlü cevap; model ile yürütme katmanını ayırır, state/checkpoint, tool permissions, idempotency, observability, validation, sandbox ve human approval sorumluluklarını anlatır. Ayrıca basit soru-cevap için tam harness'ın gereksiz olabileceğini belirtir.

## Related Pages

- [Agent Workflow](agent-workflow.md)
- [Agent Orchestration](agent-orchestration.md)
- [Agent Instructions](agent-instructions.md)
- [AI Caginda Judgment](ai-caginda-judgment.md)
- [Classic Agent vs Agent Harness](../syntheses/classic-agent-vs-agent-harness.md)
- [Single Agent vs Agent Orchestration](../syntheses/single-agent-vs-agent-orchestration.md)
- [Agent harness nedir?](../interview/agent-harness-nedir.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `raw/tweets/2026-06-28-agent-harness-vs-classic-agent.md`

## Open Questions

- Bu repo için minimum harness sınırı helper scriptler, agent talimatları ve validation'dan başka hangi bileşenleri içermeli?
- Agent run state'i Git içinde mi, lokal bir store'da mı, yoksa harici bir veritabanında mı tutulmalı?
- Tool permission ve human approval politikaları görev riskine göre nasıl sınıflandırılmalı?
- Harness kalitesi completion rate, recovery rate, maliyet, latency ve insan müdahalesiyle nasıl birlikte ölçülmeli?
