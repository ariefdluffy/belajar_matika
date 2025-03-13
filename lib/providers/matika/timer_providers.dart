import 'package:belajar_matika/providers/matika/game_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier(ref);
});

class TimerNotifier extends StateNotifier<int> {
  Timer? _timer;
  final Ref ref;

  TimerNotifier(this.ref) : super(25); // Timer mulai dari 5 detik

  void startTimer() {
    _timer?.cancel();
    state = 25; // Reset timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == 1) {
        ref
            .read(gameProvider.notifier)
            .checkAnswer(-1); // Jawaban salah jika waktu habis
        resetTimer();
      } else {
        state--;
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    state = 25;
  }
}
