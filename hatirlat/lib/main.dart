import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'hatirlatici.dart';
import 'not_ekle.dart';
import 'ayarlar.dart';

// Global bildirim değişkeni
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // Android için başlatma ayarları
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // Genel başlatma ayarları
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  // Bildirimleri başlat
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Bildirime tıklanınca yapılacak işlemler (isteğe bağlı)
    },
  );

  runApp(GunPlanlayiciApp());
}

class GunPlanlayiciApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  Color backgroundColor = Colors.white;
  List<Map<String, String>> notlar = [];
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _notlariYukle();
    _ayarlarYukle(); // Ayarları yükleyip arka planı ayarla
  }

  Future<void> _ayarlarYukle() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/ayarlar.txt');

      if (await file.exists()) {
        String ayarlar = await file.readAsString();
        List<String> ayarListesi = ayarlar.split(';');

        setState(() {
          backgroundColor = _renkBul(ayarListesi[1].trim()); // String'i Color'a dönüştür
        });
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

// String'i Color'a dönüştüren yardımcı metod
  Color _renkBul(String renkAdi) {
    switch (renkAdi) {
      case "Okyanus Mavisi":
        return Color(0xFFE3F2FD);
      case "Doğa Yeşili":
        return Color(0xFFE8F5E9);
      case "Gökyüzü Gri":
        return Color(0xFFF5F5F5);
      case "Güneş Sarısı":
        return Color(0xFFFFFDE7);
      default:
        return Colors.white; // Varsayılan renk
    }
  }


  Future<void> _notlariYukle() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notlar.txt');

      if (await file.exists()) {
        List<String> satirlar = await file.readAsLines();
        setState(() {
          notlar = satirlar.map((satir) {
            List<String> parcalar = satir.split(';');
            return {
              "baslik": parcalar[0],
              "icerik": parcalar.length > 1 ? parcalar[1] : "Bilinmiyor",
              "zaman": parcalar.length > 2 ? parcalar[2] : "Bilinmiyor",
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlarım', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotEklePage(backgroundColor: backgroundColor),
                ),
              );
              await _notlariYukle();
            },
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: notlar.isEmpty
            ? Center(
          child: Text(
            'Henüz bir not yok.',
            style: TextStyle(
              fontSize: 18,
              color: backgroundColor == Colors.black ? Colors.white : Colors.black,
            ),
          ),
        )
            : ListView.builder(
          itemCount: notlar.length,
          itemBuilder: (context, index) {
            final not = notlar[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  tileColor: Colors.grey[100],
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.note, color: Colors.white),
                  ),
                  title: Text(
                    not['baslik'] ?? "Başlık Yok",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(not['icerik'] ?? "İçerik Yok"),
                      SizedBox(height: 8),
                      Text(
                        not['zaman'] ?? "Zaman Yok",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool confirm = await _confirmDelete(context);
                      if (confirm) {
                        await _notuSil(index);
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) async {
          if (index == 0) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HatirlaticiSayfasi(backgroundColor: backgroundColor),
              ),
            );
            await _notlariYukle();
          } else if (index == 2) {
            final selectedColor = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AyarlarSayfasi(initialColor: backgroundColor),
              ),
            );

            if (selectedColor != null) {
              setState(() {
                backgroundColor = selectedColor;
              });
            }
          }
          setState(() {
           // _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Hatırlatıcı'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notu Sil'),
          content: const Text('Bu notu silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Hayır'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Evet'),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  Future<void> _notuSil(int index) async {
    setState(() {
      notlar.removeAt(index);
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notlar.txt');

      if (await file.exists()) {
        final mevcutNotlar = await file.readAsLines();
        mevcutNotlar.removeAt(index);
        await file.writeAsString(mevcutNotlar.join('\n'));
      }
    } catch (e) {
      print("Hata: $e");
    }
  }
}
