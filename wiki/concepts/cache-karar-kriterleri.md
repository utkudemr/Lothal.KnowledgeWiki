# Cache Karar Kriterleri

## Short Definition

Cache karar kriterleri, bir verinin cache'e alinip alinmayacagini frekans, okuma maliyeti, veri stabilitesi, veri boyutu, kullanici deneyimi, guvenlik ve olceklenebilirlik acisindan bilincli degerlendirme yaklasimidir.

## Why It Matters

Cache genellikle performans cozumu gibi gorunur, fakat yanlis kullanildiginda correctness, debug edilebilirlik, guvenlik ve operasyon maliyeti problemi uretir. Bir sorguyu Redis ile hizlandirmak kolaydir; hangi verinin ne kadar sureyle, hangi anahtarla, hangi invalidation kuralina bagli olarak tutulacagini aciklamak daha zordur.

Bu yuzden cache bir refleks degil, mimari karar olmalidir. Her cache key'i sistemde yeni bir sozlesme, yeni bir stale data ihtimali ve yeni bir operasyonel sorumluluk yaratir.

## Key Ideas

- Sik okunan ve pahali uretilen veri cache icin daha iyi adaydir.
- Nadiren okunan veya zaten ucuz olan veri cache'e alindiginda bellek ve karmasiklik israfi yaratir.
- Stabil veri uzun TTL ile tutulabilir; volatil veri kisa TTL, explicit invalidation veya hic cache kullanmama karari gerektirir.
- Buyuk, nested veya serialize/deserialize maliyeti yuksek payload'lar cache'i yavaslatabilir.
- Kullanici deneyiminin kritik path'inde olan okumalarda cache daha yuksek deger uretir.
- Hassas, kullaniciya ozel veya tenant'a ozel veri yanlis key tasarimiyla veri sizintisina yol acabilir.
- Yuksek cardinality, kontrolsuz TTL ve kotu eviction politikasi cache hit ratio'yu dusurup eviction churn yaratabilir.

## Example

Bir e-ticaret sisteminde ulke listesi, kategori menusu veya kampanya kurallari gibi nispeten stabil ve cok okunan veriler Redis'te cache'lenebilir. Buna karsin flash sale stok miktari her saniye degisiyorsa, stale stok bilgisi kullanici guvenini ve satis dogrulugunu bozabilir. Bu veri cache'lenecekse cok kisa TTL, event tabanli invalidation veya merkezi stok rezervasyon servisiyle birlikte tasarlanmalidir.

Benzer sekilde, bir dashboard'un pahali aggregate sonucu cache icin iyi aday olabilir. Fakat primary key ile index'li bir tablodan tek satir okumak zaten hizliysa, cache sadece ekstra invalidation ve debug maliyeti ekleyebilir.

## .NET / Backend Relevance

.NET backend sistemlerinde cache genellikle `IMemoryCache`, `IDistributedCache`, Redis, CDN, HTTP cache header'lari veya uygulama seviyesinde read model cache'leriyle uygulanir. Kritik nokta teknoloji degil, karar modelidir.

ASP.NET Core API icin pratik sorular:

- Bu endpoint gercekten read-heavy mi?
- DB sorgusu, external service call veya hesaplama maliyeti cache'i hakli cikariyor mu?
- Response kullaniciya, tenant'a, role'e veya locale'e gore degisiyor mu?
- Cache key bu scope'lari guvenli bicimde iceriyor mu?
- TTL yeterli mi, yoksa domain event ile invalidation gerekiyor mu?
- Hit/miss ratio, memory usage, eviction ve stale data olaylari izleniyor mu?

Microservice mimarisinde cache, servisler arasi bagimliligi azaltabilir; fakat her servis kendi stale kopyasini tuttugunda tutarlilik sorunu buyur. Bu nedenle cache, outbox/inbox event'leri, domain event invalidation, idempotent update ve observability ile birlikte dusunulmelidir.

## Interview Relevance

System design mulakatlarinda "Redis ekleriz" cevabi tek basina zayiftir. Guclu cevap, cache kararini frekans, maliyet, veri degisim hizi, guvenlik, invalidation, TTL, eviction ve monitoring uzerinden savunur.

Iyi bir cevapta su cumle net olmalidir: "Cache'i sadece hiz icin degil, belirli bir bottleneck'i belirli bir stale data toleransiyla azaltmak icin eklerim."

## Related Pages

- [Cache vs Source of Truth](../syntheses/cache-vs-source-of-truth.md)
- [Cache ne zaman kullanilmali?](../interview/cache-ne-zaman-kullanilmali.md)
- [Local-first Software](local-first-software.md)
- [Cloud-first vs Offline-first vs Local-first](../syntheses/cloud-first-vs-offline-first-vs-local-first.md)
- [RAG](rag.md)

## Source References

- `raw/articles/2026-06-21-to-cache-or-not-to-cache.md`

## Open Questions

- Retail/POS domain'inde fiyat, kampanya ve stok verileri icin kabul edilebilir stale data suresi ne olmalidir?
- Bu wiki icin ileride cache kararlarini standartlastiran bir checklist veya design review template'i gerekli mi?
- Agent workflow'larinda pahali kaynak okuma veya validation sonucu cache'lenirse correctness riski nasil yonetilmeli?
