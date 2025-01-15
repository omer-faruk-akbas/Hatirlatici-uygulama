import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final Map<String, Color> renkHaritasi = {
  "Beyaz": Colors.white,
  "Okyanus Mavisi": Color(0xFFE3F2FD),
  "Doğa Yeşili": Color(0xFFE8F5E9),
  "Gökyüzü Gri": Color(0xFFF5F5F5),
  "Güneş Sarısı": Color(0xFFFFFDE7),
};

class AyarlarSayfasi extends StatefulWidget {
  final Color initialColor;

  AyarlarSayfasi({required this.initialColor});

  @override
  _AyarlarSayfasiState createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  bool bildirimIstiyorum = true; // Varsayılan olarak bildirim açık
  String uygulamaRengi = "Beyaz";
  String secilenBildirimSesi = "notification"; // Varsayılan bildirim sesi

  final List<String> uygulamaRenkleri = [
    "Beyaz",
    "Okyanus Mavisi",
    "Doğa Yeşili",
    "Gökyüzü Gri",
    "Güneş Sarısı"
  ];

  final List<String> bildirimSesleri = [
    "notification", // notification.mp3
    "klasik", // klasik.mp3
    "standart" // standart.mp3
  ];

  @override
  void initState() {
    super.initState();
    _ayarlarYukle(); // Uygulama başlangıcında ayarları yükle
  }

  Future<void> _ayarlarKaydet() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/ayarlar.txt');
      String ayarlar = "$bildirimIstiyorum;$uygulamaRengi;$secilenBildirimSesi";
      await file.writeAsString(ayarlar);
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> _ayarlarYukle() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/ayarlar.txt');
      if (await file.exists()) {
        String ayarlar = await file.readAsString();
        List<String> ayarListesi = ayarlar.split(';');
        setState(() {
          bildirimIstiyorum = ayarListesi[0] == 'true';
          uygulamaRengi = ayarListesi[1];
          secilenBildirimSesi = ayarListesi[2];
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
        title: const Text("Ayarlar"),
        backgroundColor: renkHaritasi[uygulamaRengi],
      ),
      body: Container(
        color: renkHaritasi[uygulamaRengi],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bildirim Ayarları",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: const Text(
                  "Bildirim İstiyorum",
                  style: TextStyle(fontSize: 18),
                ),
                value: bildirimIstiyorum,
                activeColor: Colors.teal,
                onChanged: (value) {
                  setState(() {
                    bildirimIstiyorum = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Bildirim Sesi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButtonFormField<String>(
                  value: secilenBildirimSesi,
                  items: bildirimSesleri.map((ses) {
                    return DropdownMenuItem<String>(
                      value: ses,
                      child: Text(
                        ses,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => secilenBildirimSesi = value!),
                  decoration: const InputDecoration.collapsed(hintText: ""),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Uygulama Rengi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButtonFormField<String>(
                  value: uygulamaRengi,
                  items: uygulamaRenkleri.map((renk) {
                    return DropdownMenuItem<String>(
                      value: renk,
                      child: Text(
                        renk,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => uygulamaRengi = value!),
                  decoration: const InputDecoration.collapsed(hintText: ""),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _ayarlarKaydet();
                  Navigator.pop(context, renkHaritasi[uygulamaRengi]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 14.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  "Kaydet ve Geri Dön",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
