# Cache vs Source of Truth

## Summary

Bu sentez, cache'in performans icin kullanilan turetilmis ve gecici bir kopya olmasi ile source of truth'un domain acisindan yetkili veri kaynagi olmasi arasindaki farki aciklar.

Kaynagin ana uyarisi sudur: cache hiz kazandirabilir, fakat hangi verinin gercek oldugu belirsizlesirse sistem daha hizli degil, daha kirilgan hale gelir.

## Compared Ideas

- [Cache Karar Kriterleri](../concepts/cache-karar-kriterleri.md): Bir veriyi cache'e almadan once sorulmasi gereken pratik sorular.
- [Local-first Software](../concepts/local-first-software.md): Lokal kopyanin cache degil, kullanicinin birincil calisma kopyasi oldugu mimari model.
- Cloud-first read cache: Server veya database source of truth kalirken, okuma performansi icin gecici kopyalar kullanmak.
- Offline-first cache/queue: Ag yokken calismayi surdurmek icin lokal kopya ve kuyruk kullanmak.

## Key Differences

Cache, dogrulugu baska bir kaynaktan turetilen bir hizlandirma katmanidir. TTL dolar, invalidation calisir veya bellek baskisi olursa silinebilir. Bu nedenle cache kaybi sistemin dogrulugunu bozmamali, en fazla performansi dusurmelidir.

Source of truth ise domain kararlarinin dayandigi yetkili kayittir. Odeme, stok rezervasyonu, fiyat karari veya kullanici yetkisi gibi alanlarda hangi kaydin nihai oldugu net degilse, cache performans optimizasyonu olmaktan cikip correctness riskine donusur.

Local-first yaklasim bu ayrimi daha da belirginlestirir: lokal veri sadece offline cache degilse, ona cache gibi davranmak yanlistir. Bu durumda conflict resolution, version history ve sync protokolleri cache invalidation'dan daha merkezi problemlerdir.

## Practical Takeaways

- Cache, source of truth'un yerine gecmemelidir; hangi verinin yetkili oldugu tasarimda acik kalmalidir.
- Stale data kabul edilemiyorsa cache kullanmamak, kotu tasarlanmis cache kullanmaktan daha iyidir.
- Fiyat, stok, kampanya ve yetki gibi alanlarda cache key scope'u, TTL ve invalidation domain kurallariyla birlikte tasarlanmalidir.
- Offline-first sistemlerde lokal kopya bazen cache, bazen pending work queue, bazen de gecici read model olabilir; bu roller karistirilmamalidir.
- Local-first sistemlerde lokal veri birincil kabul ediliyorsa, "cache temizle gecsin" yaklasimi veri kaybi veya conflict yaratabilir.

## When To Use Which

Cache kullan:

- Veri sik okunuyor, pahali uretiliyor ve belirli bir sure stale kalmasi kabul edilebiliyorsa.
- Cache kaybi sadece performansi dusuruyor, domain dogrulugunu bozmuyorsa.
- TTL, invalidation, key scope ve monitoring acik tasarlandiysa.

Source of truth'a dogrudan git:

- Islem finansal, guvenlik kritik veya guclu tutarlilik gerektiriyorsa.
- Stale cevap kullaniciya yanlis fiyat, yanlis yetki veya yanlis stok gosterecekse.
- Cache'in neden var oldugu, ne zaman invalid edilecegi veya nasil olceklenecegi acik degilse.

Local-first model dusun:

- Kullanici verisi cihazda anlamli, uzun omurlu ve offline calismaya uygun olmaliysa.
- Lokal kopya sadece hizlandirma degil, urunun temel veri modeli ise.
- Sync ve conflict handling urun deneyiminin core parcasiysa.

## .NET / Backend Relevance

.NET backend tarafinda bu ayrim CQRS ve read model dusuncesiyle yakindan ilgilidir. Redis cache veya `IDistributedCache` gecici performans katmani olabilir; read model ise event'lerden turetilen, tekrar insa edilebilir ama daha belirgin sozlesmesi olan bir projeksiyondur.

POS orneginde:

- Ulke, vergi sinifi veya terminal ayari gibi stabil referans veriler cache'e uygun olabilir.
- Kampanya hesaplama sonucu kisa TTL ile cache'lenebilir, fakat kampanya degisince invalidation gerekir.
- Stok rezervasyonu veya odeme provizyonu source of truth'a yakin ve guclu tutarlilik isteyen bir akistir.
- Offline satis kuyrugu cache degil, sonradan reconcile edilecek domain isidir.

Bu ayrim observability icin de onemlidir. Log ve metric'lerde response'un cache hit mi miss mi oldugu, hangi key ile geldigi, hangi TTL kullanildigi ve invalidation'in ne zaman calistigi gorulebilmelidir.

## Related Pages

- [Cache Karar Kriterleri](../concepts/cache-karar-kriterleri.md)
- [Cache ne zaman kullanilmali?](../interview/cache-ne-zaman-kullanilmali.md)
- [Local-first Software](../concepts/local-first-software.md)
- [Cloud-first vs Offline-first vs Local-first](cloud-first-vs-offline-first-vs-local-first.md)
- [RAG](../concepts/rag.md)

## Source References

- `vault://raw/articles/2026-06-21-to-cache-or-not-to-cache.md`
- `vault://raw/articles/2026-06-20-local-first-software.md`

## Open Questions

- POS senaryolarinda fiyat ve kampanya icin source of truth siniri servis bazinda mi, terminal bazinda mi cizilmeli?
- Cache hit ratio kadar stale data olaylarini da olcen standart bir observability modeli gerekli mi?
- Read model, cache ve local-first veri kopyasi arasindaki terminoloji bu wiki'de ayri bir sentezle derinlestirilmeli mi?
