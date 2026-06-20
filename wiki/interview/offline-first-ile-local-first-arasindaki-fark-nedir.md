# Offline-first ile local-first arasindaki fark nedir?

## Short Answer

Offline-first, uygulamanin ag yokken de calisabilmesine odaklanir. Local-first ise daha genis bir mimari yaklasimdir: verinin birincil kopyasi kullanicinin cihazindadir; sunucu sync, backup ve isbirligi icin destekleyici rol oynar.

## Strong Answer

Offline-first genellikle cloud-first mimariye eklenen dayaniklilik katmani gibi dusunulebilir. Client lokal cache, queue veya embedded database kullanir; ag geldiginde degisiklikleri server'a yollar. Nihai otorite cogu zaman server'dir.

Local-first'te ise zihinsel model farklidir. Kullanici cihazindaki veri cache degil, gercek calisma kopyasidir. Uygulama yerelde hizli calisir, offline yazmaya izin verir, baska cihazlarla veya kullanicilarla sonradan senkronize olur. Sunucu hala olabilir ama kritik path uzerinde tek otorite olmak zorunda degildir.

Bu fark backend tasarimini degistirir. Local-first sistemde conflict resolution, version history, schema migration, idempotent sync, data export ve uzun vadeli veri sahipligi core konulardir. Offline-first'te ise daha cok retry, queue, cache invalidation ve server reconciliation konulari one cikar.

## Example From Experience

Bir POS sisteminde offline-first tasarim, internet kesilince satislari lokal kuyruga alip ag geldiginde merkeze gondermek olabilir. Server yine nihai kayit ve mutabakat noktasi olur.

Local-first'e daha yakin bir tasarimda terminaldeki satis kayitlari, cihaz ayarlari veya magaza ici gorev state'i yerelde birincil kabul edilir. Merkez sistem bu state'i yedekler, diger cihazlara yayar ve raporlama icin kullanir. Ancak tasarim, local state'in kendi basina anlamli ve uzun omurlu olmasini hedefler.

## Common Mistakes

- Local-first'i sadece "offline cache" sanmak.
- Sunucular local-first'te hic yoktur diye dusunmek.
- Conflict resolution'i teknik detay gibi gorup domain tasarimina dahil etmemek.
- Her domain'i CRDT ile cozulebilir sanmak.
- Odeme, stok rezervasyonu veya hesap bakiyesi gibi guclu invariant gerektiren alanlarda merkezi tutarlilik ihtiyacini hafife almak.

## Related Concepts

- [Local-first Software](../concepts/local-first-software.md)
- [CRDT](../concepts/crdt.md)
- [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md)

## Source References

- `raw/articles/2026-06-20-local-first-software.md`
