# Cloud-first vs Offline-first vs Local-first

## Summary

Bu sentez, cloud-first, offline-first ve local-first yaklasimlarini veri sahipligi, latency, offline calisma, isbirligi ve backend sorumluluklari acisindan karsilastirir.

Kisa ozet:

- Cloud-first: server authoritative, client genellikle cache veya ince arayuz.
- Offline-first: uygulama ag yokken de calismaya calisir, fakat mimari hala server merkezli olabilir.
- Local-first: yerel veri birincil kabul edilir; server destekleyici peer veya servis rolundedir.

## Compared Ideas

- [Local-first Software](../concepts/local-first-software.md): local kopyayi birincil kabul eden veri ve uygulama modeli.
- [CRDT](../concepts/crdt.md): local-first isbirliginde otomatik merge icin kullanilabilecek veri yapilari.
- Cloud-first uygulama modeli: merkezi server, merkezi database ve online API bagimliligi.
- Offline-first uygulama modeli: ag kesintisinde calisabilen, fakat cogunlukla server'a sync olan uygulama modeli.

## Key Differences

Cloud-first modelde "gercek" veri server'dadir. Client request atar, server karar verir, client sonucu gosterir. Bu model authorization, merkezi raporlama ve operasyonel kontrol icin gucludur; fakat network latency ve servis kesintisi kullanici deneyimini dogrudan etkiler.

Offline-first model, cloud-first'in kullanici deneyimi zayifligini azaltir. Client lokal cache, queue veya embedded database kullanarak ag yokken calismaya devam eder. Ancak sistemin zihinsel modeli hala "server'a geri donecegiz ve server nihai karar verecek" olabilir.

Local-first model daha koklu bir degisikliktir. Yerel kopya cache degil, kullanicinin calismasinin esas kopyasidir. Server; sync, backup, discovery, remote access ve bazi hesaplama ihtiyaclari icin vardir. Bu nedenle conflict resolution, version history, schema migration ve veri sahipligi tasarimin merkezindedir.

## Practical Takeaways

- Her uygulamanin local-first olmasi gerekmez; fakat her kritik is akisi icin network bagimliligi bilincli tasarlanmalidir.
- Offline destek sadece "request failed, sonra tekrar dene" degildir; local persistence, retry, idempotency ve reconciliation gerektirir.
- Local-first yaklasim kullanici deneyimini hizlandirabilir, fakat backend sorumlulugunu ortadan kaldirmaz.
- Server'in source of truth olmadigi sistemlerde audit, access control ve conflict UX daha zor hale gelir.
- CRDT'ler isbirligi icin gucludur, fakat production mimarisinde transport, storage compaction ve permission modeli ayri cozulmelidir.

## When To Use Which

Cloud-first kullan:

- Merkezi karar, guclu tutarlilik veya regule islem gerekiyorsa.
- Odeme, hesap bakiyesi, stok rezervasyonu veya fraud kontrolu gibi invariants kritikse.
- Client cihazlarina guvenemiyorsan veya offline degisiklik kabul etmek domain icin riskliyse.

Offline-first kullan:

- Kullanici deneyimi ag kesintisine dayanikli olmaliysa.
- Form, saha operasyonu, mobil is akisi veya POS gibi isler offline devam etmeli fakat nihai mutabakat server'da yapilacaksa.
- Existing cloud-first mimariyi tamamen tersine cevirmeden daha dayanikli hale getirmek istiyorsan.

Local-first kullan:

- Kullanici verisinin sahipligi, uzun omurlulugu ve local performans urunun temel degeriyse.
- Notes, dokuman, tasarim, proje yonetimi, knowledge base veya agent workspace gibi collaborative creative state tutuluyorsa.
- Sunucu kapaninca bile uygulamanin temel islevleri calismaya devam etmeli diyorsan.

## .NET / Backend Relevance

.NET backend mimarisinde bu ayrim, API'nin rolunu degistirir. Cloud-first sistemde ASP.NET Core API genellikle command validation, persistence ve query icin merkezi kapidir. Offline-first sistemde API, client queue'lardan gelen idempotent degisiklikleri kabul etmeli, duplicate request'leri tolere etmeli ve reconciliation sonucunu donmelidir.

Local-first sistemde ise backend daha cok sync peer, backup service, identity/access service ve conflict/audit coordinator gibi davranabilir. Bu tasarim CQRS, outbox/inbox, event sourcing, append-only logs ve eventual consistency ile dogal bag kurar.

POS veya retail orneginde pratik ayrim sudur:

- Odeme provizyonu cloud-first kalabilir.
- Satis taslagi, sepet, lokal stok gorunumu ve vardiya operasyonu offline-first olabilir.
- Kullaniciya ait notlar, terminal ayarlari veya magaza ici gorev listeleri local-first modele daha uygun olabilir.

## Related Pages

- [Local-first Software](../concepts/local-first-software.md)
- [CRDT](../concepts/crdt.md)
- [Offline-first ile local-first arasindaki fark nedir?](../interview/offline-first-ile-local-first-arasindaki-fark-nedir.md)
- [Lothal KnowledgeWiki](../projects/lothal-knowledgewiki.md)

## Source References

- `vault://raw/articles/2026-06-20-local-first-software.md`

## Open Questions

- Retail/POS domain'inde local-first icin guvenlik, PCI ve fraud sinirlari nasil cizilmeli?
- Offline-first'ten local-first'e geciste hangi migration stratejileri uygulanabilir?
- Merkezi yetkilendirme ile kullanicinin lokal kopya uzerindeki kontrolu nasil dengelenmeli?
