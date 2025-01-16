# Hatırlatıcı Uygulaması (Flutter)

Bu proje, günlük görevlerinizi ve etkinliklerinizi planlamanızı, takip etmenizi ve hatırlatmalar almanızı sağlayan bir mobil uygulamadır. **Flutter** kullanılarak geliştirilmiş ve kullanıcı dostu bir arayüze sahiptir.

## 📝 Özellikler

- **Manuel Planlama:**
  - Belirli saat aralıklarında yapılacak etkinlikler manuel olarak eklenebilir ve düzenlenebilir.
  - Planlar bir liste halinde görüntülenebilir ve silinebilir.

- **Otomatik Planlama:**
  - Sabah, öğlen veya akşam zaman dilimine göre önerilen etkinliklerden bir plan oluşturabilirsiniz.
  - Kullanıcıların seçtiği etkinlikler otomatik olarak zaman dilimine uygun şekilde düzenlenir.

- **Hatırlatıcılar:**
  - Belirli bir zaman için hatırlatıcı ekleyebilirsiniz.
  - Bildirim desteğiyle belirlediğiniz zamanlarda size hatırlatma yapılır.

- **Yerel Depolama:**
  - Planlar ve hatırlatıcılar yerel TXT dosyalarında saklanır.
  - Uygulama başlatıldığında saklanan veriler otomatik olarak yüklenir.

- **Renk ve Tema Ayarları:**
  - Uygulamanın arka plan rengi ve tema seçenekleri özelleştirilebilir.
  - Bildirim sesleri kullanıcı tercihlerine göre değiştirilebilir.

## 📂 Proje Yapısı

```plaintext
├── lib/
│   ├── main.dart            # Uygulamanın başlangıç noktası
│   ├── hatirlatici.dart     # Ana yönlendirme ve plan ekranları
│   ├── manuel_plan.dart     # Manuel planlama ekranı
│   ├── otomatik_plan.dart   # Otomatik planlama ekranı
│   ├── planlarim.dart       # Kullanıcı planlarının listelendiği ekran
│   ├── not_ekle.dart        # Hatırlatıcı not ekleme ekranı
│   ├── ayarlar.dart         # Tema ve bildirim ayarları
│   └── okuma_yazma.dart     # Yerel dosya okuma ve yazma işlevleri

##💡 Kullanılan Teknolojiler
  - Programlama Dili: Dart
  - Framework: Flutter
  - Paketler:
  - flutter_local_notifications: Bildirimler için.
  - path_provider: Yerel dosya sistemine erişim için.
  - timezone: Zaman dilimi işlemleri için.

## 🚀 Çalıştırma Talimatları
  - Gereksinimler
  - Flutter SDK (En son sürüm)
  - Android Studio veya Visual Studio Code (Flutter destekli IDE)
  - Android veya iOS cihaz/simulator