import 'package:flutter/material.dart';
import 'manuel_plan.dart';
import 'otomatik_plan.dart';
import 'planlarim.dart';
import 'not_ekle.dart';

class HatirlaticiSayfasi extends StatelessWidget {
  final Color backgroundColor;

  HatirlaticiSayfasi({required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Plan Oluşturma")),
      ),
      body: Container(
        color: backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Başlık Kartı
            Card(
              color: Colors.orange[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: ListTile(
                title: Text(
                  "Planlarım",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.list, color: Colors.orange[800]),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange[800]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanlarimSayfasi(backgroundColor: backgroundColor),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Otomatik Planlayıcı Kartı
            Card(
              color: Colors.green[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: ListTile(
                title: Text(
                  "Otomatik Planlayıcı",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.auto_mode, color: Colors.green[800]),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.green[800]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtomatikPlanlayici(backgroundColor: backgroundColor),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Manuel Planlayıcı Kartı
            Card(
              color: Colors.blue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: ListTile(
                title: Text(
                  "Manuel Planlayıcı",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.edit, color: Colors.blue[800]),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue[800]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManuelPlanlayici(backgroundColor: backgroundColor),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Hatırlatıcı Kartı
            Card(
              color: Colors.purple[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: ListTile(
                title: Text(
                  "Hatırlatıcı",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.alarm, color: Colors.purple[800]),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple[800]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotEklePage(backgroundColor: backgroundColor),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.home, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
