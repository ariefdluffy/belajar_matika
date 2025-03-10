import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
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
              child: const Column(
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(50),
                  //   child: Image.asset(
                  //     "assets/logo.png", // Ganti dengan logo aplikasi
                  //     width: 80,
                  //     height: 80,
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Text(
                    "Tebak Skor",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
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
            // _buildInfoCard(
            //   icon: Icons.language,
            //   title: "Website",
            //   subtitle: "www.developerwebsite.com",
            //   isClickable: true,
            //   onTap: () => _launchURL("https://www.developerwebsite.com"),
            // ),

            // Tombol kembali
            const SizedBox(height: 30),
            // ElevatedButton.icon(
            //   onPressed: () => Navigator.push(context),
            //   icon: const Icon(Icons.arrow_back),
            //   label: const Text("Kembali"),
            //   style: ElevatedButton.styleFrom(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //     backgroundColor: Colors.blueAccent,
            //     foregroundColor: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 30),
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
