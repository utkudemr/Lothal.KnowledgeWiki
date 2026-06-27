# Local-first and Offline Okuma Rotası

## Amaç

Offline çalışabilmek ile verinin sahipliğini yerel cihaza vermek arasındaki farkı; sync, conflict resolution ve CRDT gereksinimleriyle birlikte anlamak.

## Kimler Okumalı?

- Bağlantı kesintilerinde çalışması gereken ürünler tasarlayanlar.
- Mobil, masaüstü veya edge uygulamalarında veri sahipliği kararı verenler.
- CRDT'nin ne zaman gerekli, ne zaman gereksiz karmaşıklık olduğunu anlamak isteyen backend geliştiricileri.

## 1. Önce Mimari Modelleri Karşılaştır

1. [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md) — Üç modelin veri otoritesi, bağlantı ve sync farklarını birlikte gör.
2. [Cache vs Source of Truth](../syntheses/cache-vs-source-of-truth.md) — Yerel verinin geçici kopya mı, yetkili kayıt mı olduğunu ayır.

## 2. Temel Kavramlar

1. [Local-first Software](../concepts/local-first-software.md) — Yerel veri sahipliği, hızlı UX, sync ve backup sorumluluklarını derinleştir.
2. [CRDT](../concepts/crdt.md) — Eşzamanlı değişikliklerin merkezi koordinasyon olmadan birleştirilme modelini öğren.
3. [Cache Karar Kriterleri](../concepts/cache-karar-kriterleri.md) — Offline kopyayı sıradan cache olarak modellemenin sınırlarını gör.

## 3. Mülakatla Pekiştir

1. [Offline-first ile local-first arasındaki fark nedir?](../interview/offline-first-ile-local-first-arasindaki-fark-nedir.md)

## 4. Henüz Eksik Alanlar

- Sync protokolleri ve conflict UX desenleri: To be expanded
- Local database seçimi ve migration stratejileri: To be expanded
- Tombstone, deletion propagation ve cihaz geri dönüş senaryoları: To be expanded

## Bu Rotadan Sonra Neyi Anlamalısın?

- Offline-first'in erişilebilirlik, local-first'ün ise veri otoritesi kararı olduğunu.
- Sync'in yalnızca veri taşıma değil, conflict ve ownership problemi olduğunu.
- CRDT'nin hangi eşzamanlı düzenleme problemlerinde değer ürettiğini.
- Yerel verinin cache sayılıp sayılmayacağının mimari modele bağlı olduğunu.

## Sonraki Okuma Rotaları

- [Caching and Consistency](caching-and-consistency.md) — Yerel kopya, cache ve source of truth sınırlarını pekiştir.
- [Backend System Design](backend-system-design.md) — Sync kararlarını daha geniş dağıtık sistem bağlamına taşı.
- [Interview Prep](interview-prep.md) — Mimari ayrımları cevap formatında tekrar et.

## Source References

Bu rota, bağlantı verdiği mevcut wiki sayfalarının kaynak referanslarını miras alan bir navigasyon sayfasıdır.
