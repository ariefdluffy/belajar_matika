import 'package:belajar_matika/utils/tele_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'device_info_helper.dart'; // Impor DeviceInfoHelper

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final DeviceInfoHelper deviceInfoHelper = DeviceInfoHelper(
    telegramHelper: TelegramHelper(
      botToken: dotenv.env['BOT_TOKEN'] ?? '',
      chatId: dotenv.env['CHAT_ID'] ?? '',
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
