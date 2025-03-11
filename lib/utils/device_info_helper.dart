import 'package:belajar_matika/utils/tele_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfoHelper {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final TelegramHelper telegramHelper;

  DeviceInfoHelper({required this.telegramHelper});

  // Method untuk mendapatkan informasi perangkat dan mengirim ke Telegram
  Future<void> getAndSendDeviceInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Ambil waktu pengiriman terakhir dan jumlah pengiriman
      final lastSentTime = prefs.getInt('lastSentTime') ?? 0;
      final sentCount = prefs.getInt('sentCount') ?? 0;

      // Hitung waktu saat ini
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      // Cek apakah sudah melebihi batas waktu 15 menit
      if (currentTime - lastSentTime > 15 * 60 * 1000) {
        // Jika sudah lebih dari 15 menit, reset counter
        await prefs.setInt('sentCount', 0);
      }

      // Cek apakah sudah mencapai batas 2 kali pengiriman
      if (sentCount >= 2) {
        Logger().i('Batas pengiriman telah tercapai (2 kali per 15 menit)');
        return;
      }

      String deviceId = 'Unknown';
      String model = 'Unknown';
      String manufacturer = 'Unknown';
      String type = 'Unknown';
      String brand = 'Unknown';
      String name = 'Unknown';
      String product = 'Unknown';
      String serialNumber = 'Unknown';

      if (Platform.isAndroid) {
        // Jika platform Android
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id; // Device ID
        model = androidInfo.model; // Model perangkat
        manufacturer = androidInfo.manufacturer; // Pabrikan perangkat
        type = androidInfo.type;
        brand = androidInfo.brand;
        serialNumber = androidInfo.serialNumber;
        product = androidInfo.product;
        name = androidInfo.name;
      } else if (Platform.isIOS) {
        // Jika platform iOS
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'Unknown'; // Device ID
        model = iosInfo.model ?? 'Unknown'; // Model perangkat
        manufacturer = 'Apple'; // Pabrikan perangkat
      }

      // Buat pesan log
      String message = 'Aplikasi Game Matika dibuka oleh pengguna:\n'
          '- Device ID: $deviceId\n'
          '- Model: $model\n'
          '- Manufacturer: $manufacturer\n'
          '- Id HP: $type\n'
          '- Brand: $brand\n'
          '- Name: $name\n'
          '- Produk: $product\n'
          '- Serial Number: $serialNumber\n'
          '- Waktu: ${DateTime.now()}';

      // Kirim pesan ke Telegram
      await telegramHelper.sendMessage(message);
    } catch (e) {
      throw Exception(
          'Gagal mendapatkan atau mengirim informasi perangkat: $e');
    }
  }
}
