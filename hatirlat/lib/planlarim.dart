import 'package:flutter/material.dart';
import 'okuma_yazma.dart';

class PlanlarimSayfasi extends StatefulWidget {
  final Color backgroundColor;

  PlanlarimSayfasi({required this.backgroundColor});

  @override
  _PlanlarimSayfasiState createState() => _PlanlarimSayfasiState();
}

class _PlanlarimSayfasiState extends State<PlanlarimSayfasi> {
  List<Map<String, String>> planlar = []; // Planların tutulduğu liste

  @override
  void initState() {
    super.initState();
    // Planları txt dosyasından yükle
    planlariTxtDosyasindanYukle().then((loadedPlans) {
      setState(() {
        planlar = loadedPlans;
      });
    });
  }

  // Planı sil ve güncellenen listeyi kaydet
  Future<void> planSil(int index) async {
    setState(() {
      planlar.removeAt(index); // Listeden planı kaldır
    });

    // Güncellenen listeyi txt dosyasına kaydet
    await planlariTxtDosyasinaKaydet(planlar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planlarım"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: widget.backgroundColor,
        child: planlar.isEmpty
            ? Center(
          child: Text(
            "Henüz bir plan yok.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          itemCount: planlar.length,
          itemBuilder: (context, index) {
            final saat = planlar[index]["saat"]!;
            final aktivite = planlar[index]["aktivite"]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.schedule,
                      color: Colors.teal,
                    ),
                    title: Text(
                      saat,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      aktivite,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    trailing: Checkbox(
                      value: false,
                      onChanged: (value) {
                        if (value == true) {
                          planSil(index); // Planı sil
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
