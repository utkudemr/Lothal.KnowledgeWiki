# Caching and Consistency Okuma Rotası

## Amaç

Cache'i otomatik bir performans reçetesi olarak değil; source of truth, invalidation, stale data, güvenlik ve bağlantı modeliyle birlikte verilmesi gereken bir sistem tasarımı kararı olarak değerlendirmek.

## Kimler Okumalı?

- Redis veya benzeri bir cache eklemeyi değerlendiren .NET backend geliştiricileri.
- Tutarlılık ve performans trade-off'larını system design mülakatında açıklamak isteyenler.
- Local-first/offline tasarımlarda cache ile yetkili yerel veriyi karıştırmak istemeyenler.

## 1. Önce Ayrımı Kur

1. [Cache vs Source of Truth](../syntheses/cache-vs-source-of-truth.md) — Cache ile yetkili domain kaydı arasındaki temel sınırı kur.
2. [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md) — Yerel kopyanın hangi modelde cache, hangi modelde yetkili veri olduğunu karşılaştır.

## 2. Cache Kararını Derinleştir

1. [Cache Karar Kriterleri](../concepts/cache-karar-kriterleri.md) — Okuma sıklığı, hesaplama maliyeti, TTL, invalidation ve hassas veri boyutlarını değerlendir.
2. [Local-first Software](../concepts/local-first-software.md) — Yerel verinin her zaman cache olmadığını veri sahipliği üzerinden gör.
3. [CRDT](../concepts/crdt.md) — Birden fazla yetkili kopyanın merge ihtiyacının klasik cache probleminden nasıl ayrıldığını incele.

## 3. Mülakatla Pekiştir

1. [Cache ne zaman kullanılmalı?](../interview/cache-ne-zaman-kullanilmali.md)
2. [Offline-first ile local-first arasındaki fark nedir?](../interview/offline-first-ile-local-first-arasindaki-fark-nedir.md)

## Bu Rotadan Sonra Neyi Anlamalısın?

- Cache eklemeden önce ölçülmesi gereken maliyet ve erişim kalıplarını.
- TTL, invalidation ve stale data risklerinin iş gereksinimleriyle ilişkisini.
- Cache-aside gibi bir performans kopyasıyla local-first veri sahipliğinin farkını.
- “Hızlı okuma” ihtiyacının source of truth kararını neden değiştirmemesi gerektiğini.

## Sonraki Okuma Rotaları

- [Backend System Design](backend-system-design.md) — Cache kararını daha geniş mimari sınırlar içinde konumlandır.
- [Local-first and Offline](local-first-and-offline.md) — Yerel veri, sync ve conflict resolution konularını derinleştir.
- [Interview Prep](interview-prep.md) — Cache ve tutarlılık cevaplarını tekrar et.

## Source References

Bu rota, bağlantı verdiği mevcut wiki sayfalarının kaynak referanslarını miras alan bir navigasyon sayfasıdır.
