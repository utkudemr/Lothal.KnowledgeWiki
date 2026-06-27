# Backend System Design Okuma Rotası

## Amaç

Backend system design kararlarını teknoloji listesinden önce veri otoritesi, performans kopyaları, bağlantı koşulları ve dağıtık birleştirme ihtiyaçları üzerinden düşünmek.

## Kimler Okumalı?

- .NET backend ve system design mülakatlarına hazırlananlar.
- Cache, source of truth ve istemci veri sahipliği sınırlarını netleştirmek isteyenler.
- Dağıtık sistem kararlarını trade-off'larla açıklamak isteyenler.

## 1. Veri Otoritesi ve Sistem Sınırları

1. [Cache vs Source of Truth](../syntheses/cache-vs-source-of-truth.md) — Yetkili domain kaydı ile geçici performans kopyasını ayır.
2. [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md) — Veri sahipliği ve bağlantı varsayımlarının mimariyi nasıl değiştirdiğini gör.

## 2. Kararları Kavramlarla Derinleştir

1. [Cache Karar Kriterleri](../concepts/cache-karar-kriterleri.md) — Frekans, maliyet, stabilite, güvenlik ve ölçek açısından cache kararını değerlendir.
2. [Local-first Software](../concepts/local-first-software.md) — Yerel veri otoritesinin sync ve conflict resolution üzerindeki etkisini öğren.
3. [CRDT](../concepts/crdt.md) — Eşzamanlı dağıtık değişikliklerin deterministik birleşimi için kullanılan yaklaşımı incele.

## 3. Mülakatla Pekiştir

1. [Cache ne zaman kullanılmalı?](../interview/cache-ne-zaman-kullanilmali.md)
2. [Offline-first ile local-first arasındaki fark nedir?](../interview/offline-first-ile-local-first-arasindaki-fark-nedir.md)

## 4. Henüz Eksik System Design Alanları

- API ölçekleme, load balancing ve rate limiting: To be expanded
- Messaging, outbox/inbox ve idempotency: To be expanded
- Database partitioning, replication ve transaction sınırları: To be expanded
- Observability, resilience ve failure recovery: To be expanded

## Bu Rotadan Sonra Neyi Anlamalısın?

- Bir sistemde source of truth'un açıkça belirlenmesinin neden temel karar olduğunu.
- Cache'in performans aracı olduğunu ve veri otoritesi yerine geçirilmemesi gerektiğini.
- Cloud-first, offline-first ve local-first yaklaşımlarının aynı şey olmadığını.
- CRDT'nin her offline senaryo için varsayılan çözüm olmadığını.
- Mevcut wiki'nin backend system design kapsamının hangi alanlarda genişlemeye ihtiyaç duyduğunu.

## Sonraki Okuma Rotaları

- [Caching and Consistency](caching-and-consistency.md) — Cache invalidation ve tutarlılık kararlarını derinleştir.
- [Local-first and Offline](local-first-and-offline.md) — İstemci veri sahipliği ve sync modellerine odaklan.
- [Interview Prep](interview-prep.md) — Kararları kısa ve savunulabilir mülakat cevaplarına dönüştür.

## Source References

Bu rota, bağlantı verdiği mevcut wiki sayfalarının kaynak referanslarını miras alan bir navigasyon sayfasıdır.
