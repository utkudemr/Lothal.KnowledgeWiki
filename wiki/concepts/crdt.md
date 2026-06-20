# CRDT

## Short Definition

CRDT, yani Conflict-free Replicated Data Type, birden fazla kopyasi farkli cihazlarda veya node'larda ayni anda degisebilen ve bu degisiklikleri merkezi koordinasyon olmadan deterministik sekilde birlestirebilen veri yapisi ailesidir.

## Why It Matters

Distributed sistemlerde her yazma islemini merkezi bir liderden gecirmek latency, availability ve offline calisma acisindan pahali olabilir. CRDT'ler, ozellikle collaborative editing ve local-first uygulamalarda, farkli kullanicilarin ayni dokuman uzerinde ag kesintisi veya es zamanli calisma sirasinda degisiklik yapabilmesini saglar.

CRDT'nin vaadi sudur: iki replica farkli sirayla degisiklik alsa bile, tum degisiklikler sonunda goruldugunde ayni sonuca ulasir.

## Key Ideas

- Her replica lokal degisiklik yapabilir.
- Degisiklikler daha sonra diger replica'lara tasinir.
- Merge islemi deterministik ve conflict-free olacak sekilde tanimlanir.
- Es zamanli degisiklikler manuel merge conflict'e donusmeden uygulama tarafindan cozulur.
- CRDT sadece merge algoritmasini cozer; network transport, access control, storage compaction ve UX hala ayri problemlerdir.
- CRDT history buyuyebilir; performans ve disk/memory kullanimi ciddi tasarim konusudur.

## Example

Bir kanban uygulamasinda iki kullanici ayni anda farkli islemler yapsin:

- Kullanici A bir karta yorum ekler.
- Kullanici B ayni karti baska kolona tasir.

CRDT tabanli modelde bu iki degisiklik sonradan birlestirildiginde kart hem yeni kolonda olur hem de yorumu icerir. Geleneksel dosya sync modelinde bu durum "conflicted copy" gibi manuel cozulmesi gereken bir probleme donusebilir.

## Automerge Nerede Duruyor?

Automerge, local-first kaynaginda yalnizca gelecekte arastirilacak bir fikir olarak degil, Ink & Switch tarafindan gelistirilen acik kaynak bir JavaScript CRDT implementasyonu olarak konumlanir. JSON CRDT arastirmasina dayanir ve Trellis, Pixelpusher ve PushPin gibi local-first prototiplerde veri katmani olarak kullanilmistir.

Bu prototiplerde Automerge'in ana rolu, kullanicilarin ayni dokuman uzerinde es zamanli yaptigi degisiklikleri otomatik olarak merge etmektir. Kaynak, Automerge'i local-first isbirligi icin umut verici bir pratik deney zemini olarak anlatir; fakat teknolojinin hala deneysel oldugunu ve bugun Firebase gibi olgun production sistemlerinin yerine dogrudan gecirilmesinin onerilmedigini de vurgular.

## .NET / Backend Relevance

.NET backend sistemlerinde CRDT'ler her problem icin ilk tercih degildir. Finansal mutabakat, odeme, envanter rezervasyonu veya stok dusme gibi domain'lerde guclu tutarlilik ve domain invariant'lari gerekebilir. Fakat collaborative notes, offline form doldurma, cihazlar arasi state sync, read model preference'lari veya agent workspace state'i gibi alanlarda CRDT fikri cok degerlidir.

Backend tasariminda CRDT dusuncesi su konulari netlestirir:

- Hangi state otomatik merge edilebilir?
- Hangi conflict domain karari gerektirir?
- Hangi operasyon idempotent ve commutative tasarlanabilir?
- Hangi veriler append-only event olarak saklanabilir?
- Hangi sync hatalari UI'da gorunur olmalidir?

## Interview Relevance

CRDT konusu distributed systems mulakatlarinda "offline collaboration nasil calisir?", "eventual consistency ile conflict resolution nasil tasarlanir?" veya "Google Docs benzeri isbirligi nasil modellenir?" sorularinda gelebilir.

Guclu cevap CRDT'yi sihirli bir veritabani gibi anlatmaz. CRDT'nin merge problemini azalttigini, fakat network, authorization, storage growth, schema migration ve kullaniciya history/conflict gosterme problemlerini tek basina cozmedigini belirtir.

## Related Pages

- [Local-first Software](local-first-software.md)
- [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md)
- [Offline-first ile local-first arasindaki fark nedir?](../interview/offline-first-ile-local-first-arasindaki-fark-nedir.md)

## Source References

- `raw/articles/2026-06-20-local-first-software.md`

## Open Questions

- Bu wiki icin CRDT kavrami ileride Automerge, Yjs ve Operational Transformation karsilastirmasiyla genisletilmeli mi?
- .NET tarafinda CRDT kullanimi icin olgun kutuphane ve production ornekleri nelerdir?
- Domain invariant gerektiren islemlerde CRDT ile server-side validation birlikte nasil tasarlanir?
