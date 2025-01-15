import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:vibration/vibration.dart';

class NotEklePage extends StatefulWidget {
  final Color backgroundColor;

  NotEklePage({required this.backgroundColor});

  @override
  _NotEklePageState createState() => _NotEklePageState();
}

class _NotEklePageState extends State<NotEklePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  Timer? _timer;
  Duration? _remainingTime;
  TextEditingController _notBasligiController = TextEditingController();
  TextEditingController _notIcerigiController = TextEditingController();
  DateTime? _selectedDateTime;

  // Ayar değerlerini saklamak için değişkenler
  bool bildirimIstiyorum = false; // Bildirim genel ayarı
  String secilenBildirimSesi = "notification"; // Varsayılan bildirim sesi

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones();
    _ayarlarYukle(); // Ayarları yükle
  }

  void _initializeNotifications() {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Ayarları ayarlar.txt dosyasından oku
  Future<void> _ayarlarYukle() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/ayarlar.txt');

      if (await file.exists()) {
        String ayarlar = await file.readAsString();
        List<String> ayarListesi = ayarlar.split(';');
        setState(() {
          bildirimIstiyorum = ayarListesi[0] == 'true';
          secilenBildirimSesi = ayarListesi[2]; // Kullanıcı seçimi
        });
        print("Ayarlar Yüklendi: $ayarlar");
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> _scheduleNotification(DateTime scheduledDate) async {
    // Her bildirimi planlamadan önce ayarları yeniden oku
    await _ayarlarYukle();

    if (!bildirimIstiyorum) {
      print("Bildirimler kapalı, tetiklenmedi.");
      return;
    }

    // Kanal ID'sini benzersiz yapmak için zaman damgası ekliyoruz
    String kanalId = 'channel_id_${DateTime.now().millisecondsSinceEpoch}';
    String kanalAdi = 'channel_name';
    String kanalAciklama = 'Hatırlatma Bildirimi';

    // Android için bildirim detaylarını yeniden oluştur
    final androidDetails = AndroidNotificationDetails(
    kanalId, // Dinamik kanal ID
    kanalAdi,
    channelDescription: kanalAciklama,
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(secilenBildirimSesi), // Kullanıcı seçimi
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Hatırlatma: ${_notBasligiController.text}',
    'İçerik: ${_notIcerigiController.text}',
    tz.TZDateTime.from(scheduledDate, tz.local),
    notificationDetails,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true,
    );

    print("Bildirim Planlandı: $secilenBildirimSesi (Kanal ID: $kanalId)");
  }

  void _startCountdown(DateTime selectedDate) {
    final now = DateTime.now();
    _remainingTime = selectedDate.difference(now);

    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime!.inSeconds > 0) {
          _remainingTime = _remainingTime! - Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _notuKaydet(String baslik, String icerik, DateTime zaman) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notlar.txt');
      final not = '$baslik;$icerik;${zaman.toIso8601String()}\n';
      await file.writeAsString(not, mode: FileMode.append);
    } catch (e) {
      print("Hata: $e");
    }
  }

  void _clearForm() {
    _notBasligiController.clear();
    _notIcerigiController.clear();
    setState(() {
      _selectedDateTime = null;
      _remainingTime = null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notBasligiController.dispose();
    _notIcerigiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Ekle'),
        backgroundColor: widget.backgroundColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: widget.backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Yeni Not Ekle',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _notBasligiController,
                decoration: const InputDecoration(
                  labelText: 'Not Başlığı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _notIcerigiController,
                decoration: const InputDecoration(
                  labelText: 'Not İçeriği',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                      _startCountdown(_selectedDateTime!);
                      _scheduleNotification(_selectedDateTime!);
                    }
                  }
                },
                child: const Text('Tarih ve Saat Seç'),
              ),
              const SizedBox(height: 20),
              if (_selectedDateTime != null)
                Text(
                  'Seçilen Tarih: ${_selectedDateTime!.toLocal()}',
                  style: const TextStyle(fontSize: 16),
                ),
              if (_remainingTime != null)
                Text(
                  'Kalan Zaman: ${_remainingTime!.inHours.toString().padLeft(2, '0')}:${(_remainingTime!.inMinutes % 60).toString().padLeft(2, '0')}:${(_remainingTime!.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_notBasligiController.text.isNotEmpty &&
                          _notIcerigiController.text.isNotEmpty &&
                          _selectedDateTime != null) {
                        await _notuKaydet(
                          _notBasligiController.text,
                          _notIcerigiController.text,
                          _selectedDateTime!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Not başarıyla kaydedildi!')),
                        );
                        _clearForm();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lütfen tüm alanları doldurun!'),
                          ),
                        );
                      }
                    },
                    child: const Text('Notu Kaydet'),
                  ),
                  ElevatedButton(
                    onPressed: _clearForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Formu Temizle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
