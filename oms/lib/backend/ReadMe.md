## Database

Database'i nasıl kullanabileceğinizi burda açıklamaya çalışacağım.

# Models

Models klasörümüzde database'i oluşturan classlar mevcut. Bu classlar genel olarak bizim veri alış verişimizde aracı olucak.

Her bir modelde 3 farklı constructor bulunmakta:

- Full constructor : Default constructor, bütün verileri girmenizi ister.
- Only Required Constructor : Sadece gerekli olan verileri girmenizi ister.
- From Map Constructor : Map ile obje oluşturmanızı sağlar, required fonksiyonlar yine burda da istenir. Fieldların fazla olmasında veya tabloda olmayan feildları girdiğinizde hata verir.

Bunlara ek olarak her classta to_Map fonksiyonumuz var bu fonksiyon Objeyi Map'e aktarıp size döner.

# APIs

Api klasörü altındaki fonksiyonlarda api classları bulunmakta. Her class adını taşıyan tablo ile ilgili CRUD ( Basit ekleme, çıkarma, değiştirme ve getirme ) işlemlerini yapar.

Bu kısım geliştirilecek. Şu an 4 farklı connection kullanılmakta. Bu connectionlar birleştirilip teke indirilecek ve sizin istekleriniz ile şekillenecek.

# TODOs

- Controll mechanism need to be added. (basicly same plate number etc.)
- Trees need to be added
