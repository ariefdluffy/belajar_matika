import 'package:belajar_matika/providers/ads_provider.dart';
import 'package:belajar_matika/providers/game_provider.dart';
import 'package:belajar_matika/providers/timer_providers.dart';
import 'package:belajar_matika/utils/sound_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final timer = ref.watch(timerProvider);
    final bannerAd = ref.watch(bannerAdProvider);
    bool dialogShown = false;

    // Tampilkan dialog hanya jika game over
    if (gameState.isGameOver &&
        !dialogShown &&
        (ModalRoute.of(context)?.isCurrent ?? false)) {
      dialogShown = true; // Set flag agar dialog tidak muncul berulang kali

      Future.microtask(() {
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
                  print("ini showDialog");
                  Navigator.of(context).pop();
                  ref.read(gameProvider.notifier).resetGame();
                  dialogShown =
                      false; // Reset flag agar bisa muncul lagi di permainan berikutnya
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
        title: const Text("Tebak Skor",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
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
              const SizedBox(height: 30),

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
              const SizedBox(height: 30),

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
              const SizedBox(height: 30),

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
                height: 20,
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
