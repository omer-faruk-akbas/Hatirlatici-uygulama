import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> planlariTxtDosyasinaKaydet(List<Map<String, String>> planlar) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/planlar.txt');

  List<String> satirlar = planlar.map((plan) {
    final saat = plan["saat"]!;
    final aktivite = plan["aktivite"]!;
    return "$saat;$aktivite";
  }).toList();

  await file.writeAsString(satirlar.join('\n'));
}


Future<List<Map<String, String>>> planlariTxtDosyasindanYukle() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/planlar.txt');

  if (await file.exists()) {
    List<String> satirlar = await file.readAsLines();

    return satirlar.map((satir) {
      List<String> parcalar = satir.split(';');
      return {
        "saat": parcalar[0],
        "aktivite": parcalar[1],
      };
    }).toList();
  }

  return [];
}
