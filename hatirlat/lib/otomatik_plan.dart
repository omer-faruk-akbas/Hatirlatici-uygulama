import 'package:flutter/material.dart';
import 'okuma_yazma.dart';

class OtomatikPlanlayici extends StatefulWidget {
  final Color backgroundColor;

  OtomatikPlanlayici({required this.backgroundColor});

  @override
  _OtomatikPlanlayiciState createState() => _OtomatikPlanlayiciState();
}

class _OtomatikPlanlayiciState extends State<OtomatikPlanlayici> {
  String? uygunZaman = "Sabah"; // Varsayılan zaman dilimi

  // Etkinlikler ve süreler
  Map<String, bool> sabahEtkinlikleri = {
    "İbadet ve Meditasyon (30 dk)": false,
    "Okuma Saati (1 saat)": false,
    "Erken Çalışma (2 saat)": false,
    "Kahvaltı (45 dk)": false,
    "Egzersiz (1 saat)": false,
  };

  Map<String, bool> oglenEtkinlikleri = {
    "Yoğun Çalışma (2 saat)": false,
    "Yemek Molası (1 saat)": false,
    "Kısa Yürüyüş (20 dk)": false,
    "Dinlenme ve Kahve (30 dk)": false,
    "Kişisel Gelişim (1 saat)": false,
  };

  Map<String, bool> aksamEtkinlikleri = {
    "Aileyle Vakit (2 saat)": false,
    "Spor ve Hareket (1 saat)": false,
    "Akşam Yemeği (1 saat)": false,
    "Kitap Okuma (30 dk)": false,
    "Gece Çalışması (1.5 saat)": false,
  };

  void planKaydet() {
    List<Map<String, String>> etkinlikPlanlari = [];
    int saat = 6; // Başlangıç saati
    int dakika = 0;

    void etkinlikleriEkle(Map<String, bool> etkinlikler) {
      etkinlikler.forEach((etkinlik, secildi) {
        if (secildi) {
          String baslangicSaat =
              "${saat.toString().padLeft(2, '0')}:${dakika.toString().padLeft(2, '0')}";
          int sureDakika = _sureHesapla(etkinlik);
          dakika += sureDakika;
          saat += dakika ~/ 60;
          dakika %= 60;
          String bitisSaat =
              "${saat.toString().padLeft(2, '0')}:${dakika.toString().padLeft(2, '0')}";
          etkinlikPlanlari.add({"saat": "$baslangicSaat - $bitisSaat", "aktivite": etkinlik});
        }
      });
    }

    if (uygunZaman == "Sabah") {
      etkinlikleriEkle(sabahEtkinlikleri);
    } else if (uygunZaman == "Öğlen") {
      saat = 12;
      etkinlikleriEkle(oglenEtkinlikleri);
    } else if (uygunZaman == "Akşam") {
      saat = 18;
      etkinlikleriEkle(aksamEtkinlikleri);
    }

    if (etkinlikPlanlari.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GunlukPlan(
            backgroundColor: widget.backgroundColor,
            etkinlikPlanlari: etkinlikPlanlari,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen en az bir etkinlik seçin.")),
      );
    }
  }

  int _sureHesapla(String etkinlik) {
    if (etkinlik.contains("2 saat")) return 120;
    if (etkinlik.contains("1.5 saat")) return 90;
    if (etkinlik.contains("1 saat")) return 60;
    if (etkinlik.contains("45 dk")) return 45;
    if (etkinlik.contains("30 dk")) return 30;
    if (etkinlik.contains("20 dk")) return 20;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Otomatik Planlayıcı"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: widget.backgroundColor.withOpacity(0.95),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                "Gün için uygun zaman dilimini seçin:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              RadioListTile(
                activeColor: Colors.teal,
                title: Text("Sabah (06:00 - 12:00)"),
                value: "Sabah",
                groupValue: uygunZaman,
                onChanged: (value) {
                  setState(() {
                    uygunZaman = value.toString();
                  });
                },
              ),
              RadioListTile(
                activeColor: Colors.teal,
                title: Text("Öğlen (12:00 - 18:00)"),
                value: "Öğlen",
                groupValue: uygunZaman,
                onChanged: (value) {
                  setState(() {
                    uygunZaman = value.toString();
                  });
                },
              ),
              RadioListTile(
                activeColor: Colors.teal,
                title: Text("Akşam (18:00 - 22:00)"),
                value: "Akşam",
                groupValue: uygunZaman,
                onChanged: (value) {
                  setState(() {
                    uygunZaman = value.toString();
                  });
                },
              ),
              SizedBox(height: 20),
              if (uygunZaman == "Sabah") ..._etkinlikListesi(sabahEtkinlikleri),
              if (uygunZaman == "Öğlen") ..._etkinlikListesi(oglenEtkinlikleri),
              if (uygunZaman == "Akşam") ..._etkinlikListesi(aksamEtkinlikleri),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: planKaydet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "Planı Kaydet ve Görüntüle",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _etkinlikListesi(Map<String, bool> etkinlikler) {
    return [
      Text(
        "Etkinliklerinizi seçin:",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      ...etkinlikler.entries.map(
            (entry) => CheckboxListTile(
          activeColor: Colors.teal,
          title: Text(entry.key),
          value: entry.value,
          onChanged: (value) {
            setState(() {
              etkinlikler[entry.key] = value!;
            });
          },
        ),
      ),
    ];
  }
}
class GunlukPlan extends StatelessWidget {
  final Color backgroundColor;
  final List<Map<String, String>> etkinlikPlanlari;

  GunlukPlan({
    required this.backgroundColor,
    required this.etkinlikPlanlari,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plan Detayları"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: backgroundColor, // Arka plan rengi burada uygulanıyor
        child: FutureBuilder<void>(
          future: planlariTxtDosyasinaKaydet(etkinlikPlanlari),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Hata: ${snapshot.error}"));
            } else {
              return ListView.builder(
                itemCount: etkinlikPlanlari.length,
                itemBuilder: (context, index) {
                  final plan = etkinlikPlanlari[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Kartların arka plan rengi
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.event, color: Colors.white),
                          ),
                          title: Text(
                            plan["saat"]!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(plan["aktivite"]!),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
