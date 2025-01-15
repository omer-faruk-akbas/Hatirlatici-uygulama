import 'package:flutter/material.dart';
import 'okuma_yazma.dart'; // Sağladığınız okuma ve yazma fonksiyonlarını içeren dosya

class ManuelPlanlayici extends StatefulWidget {
  final Color backgroundColor;

  ManuelPlanlayici({required this.backgroundColor});

  @override
  State<ManuelPlanlayici> createState() => _ManuelPlanlayiciState();
}

class _ManuelPlanlayiciState extends State<ManuelPlanlayici> {
  List<Map<String, String>> planlar = []; // Planların tutulduğu liste

  @override
  void initState() {
    super.initState();
    // TXT dosyasından planları yükle
    planlariTxtDosyasindanYukle().then((loadedPlans) {
      setState(() {
        planlar = loadedPlans;
      });
    });
  }

  Future<void> yeniPlanEkle(Map<String, String> yeniPlan) async {
    setState(() {
      planlar.add(yeniPlan); // Yeni planı listeye ekle
    });

    // Güncellenen listeyi txt dosyasına kaydet
    await planlariTxtDosyasinaKaydet(planlar);
  }

  Future<void> planSil(int index) async {
    setState(() {
      planlar.removeAt(index); // Seçili planı listeden kaldır
    });

    // Güncellenen listeyi txt dosyasına kaydet
    await planlariTxtDosyasinaKaydet(planlar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manuel Plan Oluşturma"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: widget.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: planlar.isEmpty
                  ? Center(
                child: Text(
                  "Henüz bir plan yok.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: planlar.length,
                itemBuilder: (context, index) {
                  final saat = planlar[index]["saat"]!;
                  final aktivite = planlar[index]["aktivite"]!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.event_note, color: Colors.teal),
                        title: Text(
                          saat,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          aktivite,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => planSil(index), // Planı sil
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Yeni Plan Ekle Butonu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final yeniPlan = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          YeniPlanEkrani(backgroundColor: widget.backgroundColor),
                    ),
                  );
                  if (yeniPlan != null) {
                    await yeniPlanEkle(yeniPlan); // Yeni planı ekle ve kaydet
                  }
                },
                icon: Icon(Icons.add),
                label: Text("Yeni Plan Ekle"),
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Yeni Plan Ekleme Ekranı
class YeniPlanEkrani extends StatefulWidget {
  final Color backgroundColor;

  YeniPlanEkrani({required this.backgroundColor});

  @override
  _YeniPlanEkraniState createState() => _YeniPlanEkraniState();
}

class _YeniPlanEkraniState extends State<YeniPlanEkrani> {
  TextEditingController aktiviteController = TextEditingController();
  TimeOfDay? baslangicSaat;
  TimeOfDay? bitisSaat;

  void planKaydet() {
    if (baslangicSaat != null &&
        bitisSaat != null &&
        aktiviteController.text.isNotEmpty) {
      String baslangic =
          "${baslangicSaat!.hour.toString().padLeft(2, '0')}:${baslangicSaat!.minute.toString().padLeft(2, '0')}";
      String bitis =
          "${bitisSaat!.hour.toString().padLeft(2, '0')}:${bitisSaat!.minute.toString().padLeft(2, '0')}";
      Navigator.pop(
          context, {"saat": "$baslangic - $bitis", "aktivite": aktiviteController.text});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lütfen tüm alanları doldurun!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Plan Ekle"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: widget.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    baslangicSaat == null
                        ? "Başlangıç Saati Seçiniz"
                        : "Başlangıç: ${baslangicSaat!.hour}:${baslangicSaat!.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          baslangicSaat = selectedTime;
                        });
                      }
                    },
                    child: Text("Seç"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bitisSaat == null
                        ? "Bitiş Saati Seçiniz"
                        : "Bitiş: ${bitisSaat!.hour}:${bitisSaat!.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: baslangicSaat ?? TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          bitisSaat = selectedTime;
                        });
                      }
                    },
                    child: Text("Seç"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: aktiviteController,
                decoration: InputDecoration(
                  labelText: "Ne yapacaksınız?",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: planKaydet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "Planı Kaydet",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
