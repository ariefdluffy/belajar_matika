import 'package:belajar_matika/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter diinisialisasi
  try {
    await dotenv.load(fileName: ".env");
    print("File .env berhasil dimuat!");
  } catch (e) {
    print("Error saat memuat .env: $e");
  }
  await SharedPreferences.getInstance(); // Inisialisasi SharedPreferences
  await MobileAds.instance.initialize();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}
