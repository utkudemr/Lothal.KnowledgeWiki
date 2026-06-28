# AI ciktilarini nasil degerlendirirsin?

## Short Answer

AI ciktisini final cevap olarak degil, incelenmesi gereken bir aday cozum olarak degerlendiririm. Once varsayimlarini aciga cikaririm, sonra domain bilgisi, kaynaklar, testler, edge case'ler ve riskler uzerinden kontrol ederim. Kritik islerde insan review'u ve deterministik validation olmadan ciktinin kalici hale gelmesine izin vermem.

## Strong Answer

LLM'ler akici ve ikna edici cevaplar uretebilir, ama bu cevaplar cogunlukla egitim verisinde en cok gorulen yaklasimlara yaslanir. Bu nedenle AI kullaniminda asil beceri sadece iyi prompt yazmak degil, ciktidan sonra judgment uygulamaktir.

Ben genelde su sorularla degerlendiririm:

- Bu cevap hangi varsayimlari yapiyor?
- Onerilen yaklasim bu sistemin hedef davranisini gercekten uretiyor mu?
- Bu en iyi cozum mu, yoksa en cok belgelenmis cozum mu?
- Hangi edge case'ler, guvenlik riskleri, performans maliyetleri veya operasyonel karmasikliklar eksik?
- Bunu production'a koymadan once hangi test, review veya validation gerekli?

Kod veya mimari karar uretildiyse build/test, observability, failure mode ve rollback acisindan bakarim. Dokumantasyon veya wiki ciktisi uretildiyse source reference, link dogrulugu, duplicate riskleri ve insan tarafindan okunabilirlik acisindan kontrol ederim.

## Example From Experience

Bir agent wiki ingest'i yaptiginda iyi gorunen bir konsept sayfasi uretebilir. Ama bu yeterli degildir. Sayfa raw source'a referans veriyor mu, mevcut sayfalarla duplicate mi, index'e eklendi mi, log'a yazildi mi, relative linkler calisiyor mu ve kaynakta olmayan iddialar eklenmis mi diye kontrol etmek gerekir.

Benzer sekilde bir .NET backend tasariminda LLM "Redis cache ekleyelim" diyebilir. Bu oneriyi hemen kabul etmek yerine once veri tazeligi, invalidation, source-of-truth, operasyonel maliyet ve alternatif cozumleri degerlendiririm. Bazen dogru cevap Redis degil, daha iyi bir SQL index'i veya read model tasarimidir.

## Common Mistakes

- AI ciktisini otoriter gorundugu icin dogru kabul etmek.
- Prompt playbook kullanmayi uzmanlik veya karar kalitesiyle karistirmak.
- Cevabin varsayimlarini sorgulamadan uygulamaya gecmek.
- Test, review ve validation adimlarini "AI zaten kontrol etti" diyerek atlamak.
- Domain bilgisi olmadan sadece supheci davranmak; bu judgment degil, yonu olmayan itirazdir.

## Related Concepts

- [AI Caginda Judgment](../concepts/ai-caginda-judgment.md)
- [Agent Workflow](../concepts/agent-workflow.md)
- [Agent Instructions](../concepts/agent-instructions.md)
- [Prompt Playbook vs Kalibre Judgment](../syntheses/prompt-playbook-vs-kalibre-judgment.md)
- [Cache Karar Kriterleri](../concepts/cache-karar-kriterleri.md)

## Source References

- `vault://raw/articles/2026-06-23-the-most-important-skill-in-the-age-of-ai-judgment.md`
