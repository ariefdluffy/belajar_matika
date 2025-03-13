import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:belajar_matika/helper/ads_banner_susun_kata_atas.dart';
import 'package:belajar_matika/helper/ads_banner_susun_kata_bawah.dart';
import 'package:belajar_matika/providers/kata/susun_kata_provider.dart';
import 'package:belajar_matika/providers/kata/susun_kata_skor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
// import 'package:lottie/lottie.dart';

class KataGameScreen extends ConsumerStatefulWidget {
  const KataGameScreen({super.key});

  @override
  ConsumerState<KataGameScreen> createState() => _KataGameScreenState();
}

class _KataGameScreenState extends ConsumerState<KataGameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  String playerName = "";

  Timer? _timer;
  int _timeLeft = 60;
  int _score = 0;
  bool isGameOver = false;

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _endGame();
      }
    });
  }

  void _playSound(String assetPath) async {
    await _audioPlayer.play(AssetSource(assetPath));
  }

  void _checkWin() {
    final gameState = ref.read(wordProvider);
    final gameNotifier = ref.read(wordProvider.notifier);

    if (!gameState.placedLetters.contains(null)) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (gameNotifier.checkWin()) {
          setState(() {
            _score += 10; // Tambah skor jika benar
          });
          _showWinDialog(_score);
        } else {
          _showWrongDialog(0);
        }
      });
    }
  }

  void _nextQuestion() {
    final gameNotifier = ref.read(wordProvider.notifier);

    if (ref.read(wordProvider).currentQuestion < 10) {
      setState(() {
        gameNotifier.nextQuestion(); // Pindah ke soal berikutnya
        _startTimer();
      });
    } else {
      _endGame();
    }
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _timeLeft = 60;
      isGameOver = false; // Reset flag game selesai
    });

    ref.read(wordProvider.notifier).resetGame(); // Reset soal
    _startTimer(); // Mulai timer baru
  }

  void _endGame() {
    if (isGameOver) return; // Cegah dialog muncul lebih dari sekali
    isGameOver = true;

    _timer?.cancel();
    ref
        .read(scoreSusunKataProvider.notifier)
        .addScoreSusunKata(playerName, _score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Permainan Selesai!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/animations/congrats.json",
                width: 150, height: 150),
            Text("Skor Akhir: $_score"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showWrongDialog(int score) {
    _playSound("sounds/wrong.mp3"); // Suara gagal
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Coba Lagi 😢"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/animations/wrong.json",
                width: 150, height: 150),
            const SizedBox(height: 10),
            Text("Susunan salah, ${ref.read(wordProvider).word}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ref.read(wordProvider.notifier).resetGame();
              _nextQuestion();
            },
            child: const Text("Lanjut"),
          ),
        ],
      ),
    );
  }

  void _showWinDialog(int score) {
    _playSound("sounds/success.mp3"); // Suara sukses
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Selamat! 🎉"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/animations/congrats.json",
                width: 150, height: 150),
            const SizedBox(height: 10),
            Text("Kata yang benar: ${ref.read(wordProvider).word}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(wordProvider.notifier).resetGame();
            },
            child: const Text("Main Lagi"),
          ),
        ],
      ),
    );
  }

  void _showNameInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/animations/hello.json",
                    width: 120, height: 120),
                const SizedBox(height: 10),
                const Text(
                  "Masukkan Nama",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Nama Anda",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          setState(() {
                            playerName = nameController.text;
                            _startTimer();
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Mulai",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Tutup dialog tanpa menyimpan nama
                      },
                      child: const Text("Langsung saja",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _showNameInputDialog());
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(wordProvider);
    final gameNotifier = ref.read(wordProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Susun Kata",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Banner Iklan di Bagian Atas
            const AdBannerSusunKataWidgetAtas(),

            // Konten Utama (Teks, Drag-and-Drop, dll.)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("⏳ Waktu: $_timeLeft detik",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _timeLeft <= 10 ? Colors.red : Colors.black)),
                  Text("📌 Soal: ${gameState.currentQuestion}/10",
                      style: const TextStyle(fontSize: 20)),
                  Text("🏆 Skor: $_score",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  const Text(
                    "Susun Kata Berikut",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    children: List.generate(gameState.word.length, (index) {
                      return DragTarget<String>(
                        onAcceptWithDetails:
                            (DragTargetDetails<String> details) {
                          _playSound("sounds/drop.mp3");
                          gameNotifier.placeLetter(index, details.data);
                          _checkWin();
                        },
                        builder: (context, candidateData, rejectedData) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                )
                              ],
                              color: gameState.placedLetters[index] == null
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.greenAccent,
                            ),
                            child: Text(
                              gameState.placedLetters[index] ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    children: gameState.shuffledLetters.map((letter) {
                      return Draggable<String>(
                        data: letter,
                        feedback: LetterBox(letter: letter, opacity: 0.7),
                        childWhenDragging:
                            const LetterBox(letter: "", opacity: 0.3),
                        child: LetterBox(letter: letter),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // const Expanded(child: AdBannerSusunKataBawah()),

            // Tombol Reset Game di Bagian Bawah
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => ref.read(wordProvider.notifier).resetGame(),
                  child: const Text(
                    "Reset Game",
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LetterBox extends StatelessWidget {
  final String letter;
  final double opacity;

  const LetterBox({super.key, required this.letter, this.opacity = 1.0});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 45,
        height: 45,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          letter,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
