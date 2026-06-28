# Cache ne zaman kullanilmali?

## Short Answer

Cache, veri sik okunuyorsa, okuma veya hesaplama maliyeti yuksekse, veri yeterince stabilse ve stale data toleransi acikca kabul edilebiliyorsa kullanilmalidir. Sadece "daha hizli olsun" diye cache eklemek dogru degildir; TTL, invalidation, guvenlik, key scope ve monitoring karariyla birlikte tasarlanmalidir.

## Strong Answer

Ben cache kararini once bottleneck ve correctness uzerinden degerlendiririm. Bir veri cok nadir okunuyorsa veya indexed DB query zaten ucuzsa cache sadece ekstra karmasiklik ekler. Ama veri read-heavy ise, external servis veya pahali aggregate gerektiriyorsa ve kullanici deneyiminin kritik path'inde yer aliyorsa cache yuksek deger uretebilir.

Sonra veri degisim hizina bakarim. Stabil referans veriler uzun TTL ile cache'lenebilir. Volatil verilerde ise kisa TTL, explicit invalidation veya domain event tabanli invalidation gerekir. Stale cevap kabul edilemiyorsa cache kullanmam veya cache'i sadece yardimci sinyal olarak kullanirim.

Son olarak guvenlik ve olceklenebilirlik kontrolu yaparim. Kullaniciya, tenant'a veya role'e gore degisen veri shared key ile tutulmamalidir. High-cardinality key'ler, sinirsiz TTL ve kotu eviction politikasi Redis'i performans cozumu olmaktan cikarip operasyon problemine donusturebilir.

## Example From Experience

Bir ASP.NET Core e-ticaret API'sinde kategori agaci, ulke listesi veya genel konfigurasyon gibi stabil veriler Redis ile cache'lenebilir. Bunlar cok okunur, nadir degisir ve stale kalma toleransi yuksektir.

Buna karsin flash sale stok miktari, kullanici bakiyesi veya odeme provizyon sonucu cache icin risklidir. Bu alanlarda stale cevap dogrudan yanlis satis, yanlis bakiye veya guvenlik problemi yaratabilir. Eger cache kullanilacaksa domain event invalidation, kisa TTL, tenant/user scoped key ve net observability gerekir.

## Common Mistakes

- Cache'i performans sorununun kaynagini olcmeden eklemek.
- Her DB sorgusunun Redis ile daha iyi olacagini varsaymak.
- TTL belirleyip invalidation ihtiyacini yok saymak.
- User-specific veya tenant-specific veriyi shared key ile cache'lemek.
- Hit ratio, eviction, memory usage ve stale data olaylarini izlememek.
- Cache'i source of truth gibi kullanmak.

## Related Concepts

- [Cache Karar Kriterleri](../concepts/cache-karar-kriterleri.md)
- [Cache vs Source of Truth](../syntheses/cache-vs-source-of-truth.md)
- [Local-first Software](../concepts/local-first-software.md)

## Source References

- `vault://raw/articles/2026-06-21-to-cache-or-not-to-cache.md`
