# Local-first Software

## Short Definition

Local-first software, kullanicinin verisini once yerel cihazda birincil kopya olarak tutan; sunuculari ise senkronizasyon, yedekleme, kesif ve isbirligi icin yardimci kopya olarak kullanan uygulama mimarisidir.

## Why It Matters

Cloud-first uygulamalarda veri genellikle sunucuda "gercek" kopya olarak durur. Kullanici cihazindaki veri ise cache gibi davranir. Bu model isbirligi ve cok cihazli erisim icin kullanislidir, fakat latency, offline calisma, veri sahipligi, gizlilik ve uzun vadeli arsivlenebilirlik acisindan maliyetlidir.

Local-first yaklasim bu onceligi tersine cevirir: kullanici calismaya devam etmek icin sunucuya muhtac olmamalidir. Uygulama yerelde hizli calisir, ag kesilince yazmaya devam eder, ag geldiginde diger cihazlarla senkronize olur.

## Key Ideas

- Yerel cihazdaki veri birincil kopya olarak kabul edilir.
- Sunucular tamamen ortadan kalkmaz; backup, multi-device sync, discovery ve burst compute gibi destek rolleri ustlenir.
- Offline destek sonradan eklenen bir cache ozelligi degil, veri modelinin temel parcasidir.
- Isbirligi icin conflict resolution, history, merge ve senkronizasyon protokolleri tasarimin merkezindedir.
- CRDT ve Operational Transformation gibi teknikler, es zamanli duzenlemeleri daha az manuel catisma ile birlestirmek icin kullanilabilir.
- Uzun omurluluk icin veri export, acik formatlar ve uygulamanin sunucu kapaninca da calisabilmesi onemlidir.
- Kullanici kontrolu, privacy ve data ownership mimari karar olarak ele alinir.

## Example

Bir magazada calisan POS uygulamasini dusun. Cloud-first modelde her satis, stok sorgusu veya odeme adimi merkezi API'ye bagimliysa ag kesintisi operasyonu durdurabilir.

Local-first yorumda terminal yerel veritabanina satis kaydeder, makbuz uretir ve stok hareketini lokal event olarak saklar. Ag geldikce bu event'ler merkeze senkronize edilir. Merkez servisler raporlama, cihazlar arasi mutabakat, yedekleme ve uzak gozetim icin kullanilir; fakat satis akisi her request'te merkeze bagimli olmaz.

Bu model "her seyi lokal yap" demek degildir. Odeme provizyonu, fraud kontrolu veya merkezi fiyat kampanyasi gibi bazi adimlar hala online olabilir. Kritik karar, hangi is akislarinin offline devam edebilecegini ve sonradan nasil reconcile edilecegini acik tasarlamaktir.

## .NET / Backend Relevance

.NET backend acisindan local-first, API merkezli tasarimdan event ve sync merkezli tasarima gecmeyi gerektirir. ASP.NET Core API tek source of truth gibi davranmak yerine, cihazlardan gelen lokal degisiklikleri kabul eden, siralayan, dogrulayan ve reconcile eden bir sync katmani olabilir.

Pratik backend konulari:

- Yerel storage: SQLite, LiteDB veya cihaz uzerinde calisan baska bir embedded store.
- Sync protokolu: degisiklik setleri, version vector, logical clock, idempotent command veya event log tasarimi.
- Conflict resolution: last-write-wins yerine domain'e uygun merge kurallari.
- Outbox/inbox: offline uretilen event'lerin guvenilir aktarimi.
- Observability: hangi cihaz hangi degisikligi ne zaman uretti, ne zaman sync edildi, hangi conflict olustu?
- Schema migration: farkli cihazlarda farkli uygulama versiyonlari varken veri formatinin geriye/ileriye uyumlulugu.

Microservice mimarisinde local-first dusunce, merkezi servislerin her zaman aninda ulasilabilir oldugu varsayimini zayiflatir. Bu da eventual consistency, idempotency, conflict handling ve audit trail konularini daha onemli hale getirir.

## Interview Relevance

Bu konu mulakatlarda offline architecture, distributed systems, eventual consistency, conflict resolution ve data ownership sorularinda kullanilabilir. Guclu cevap, local-first'i sadece "offline cache" olarak anlatmaz; yerel kopyanin birincil oldugunu, server'in destekleyici rol aldigini ve senkronizasyonun mimarinin temel problemi oldugunu soyler.

Kisa cevap kalibi:

"Offline-first genelde uygulamanin ag yokken de calismasina odaklanir. Local-first daha genis bir mimari iddiadir: veri sahipligi ve birincil kopya kullanicinin cihazindadir; cloud ise sync, backup ve isbirligi icin yardimci peer'dir. Bu nedenle conflict resolution, local persistence, history ve schema uyumlulugu core tasarim konularidir."

## Related Pages

- [CRDT](crdt.md)
- [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md)
- [Offline-first ile local-first arasindaki fark nedir?](../interview/offline-first-ile-local-first-arasindaki-fark-nedir.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `raw/articles/2026-06-20-local-first-software.md`

## Open Questions

- POS veya magaza operasyonlari icin hangi veriler local-first tutulmali, hangileri online authoritative kalmali?
- .NET ekosisteminde production-ready CRDT/sync altyapisi icin hangi kutuphaneler pratikte olgun?
- Local-first sistemlerde yetkilendirme, veri silme ve "paylasimi durdurma" semantikleri nasil modellenmeli?
