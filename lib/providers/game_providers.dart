import 'dart:async';
import 'package:belajar_matika/models/question_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(ref);
});

class GameNotifier extends StateNotifier<GameState> {
  final Ref ref;
  Timer? _timer;

  GameNotifier(this.ref)
      : super(GameState(
          score: 0,
          mistakes: 0,
          timeLeft: 60,
          isGameOver: false,
          currentQuestion: Question.generate(),
        ));

  void startGame() {
    state = state.copyWith(
      score: 0,
      mistakes: 0,
      timeLeft: 60,
      isGameOver: false,
      currentQuestion: Question.generate(),
    );
    startTimer();
  }

  void resetGame() {
    startGame();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft <= 0) {
        _endGame();
        timer.cancel();
      } else {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      }
    });
  }

  void checkAnswer(int selectedAnswer) {
    if (state.isGameOver) return;

    bool isCorrect = selectedAnswer == state.currentQuestion.answer;

    if (isCorrect) {
      state = state.copyWith(score: state.score + 1);
    } else {
      state = state.copyWith(mistakes: state.mistakes + 1);
    }

    // **Pastikan hanya memanggil game over jika salah 3x atau skor sudah cukup**
    if (state.score >= 10 || state.mistakes >= 3) {
      _endGame();
    } else {
      state = state.copyWith(currentQuestion: Question.generate());
    }
  }

  void _endGame() {
    _timer?.cancel();
    saveScore(state.score);
    state = state.copyWith(isGameOver: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Simpan skor ke SharedPreferences dengan hanya 20 skor tertinggi
  Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> scores =
        prefs.getStringList('high_scores')?.map(int.parse).toList() ?? [];

    // Tambahkan skor baru
    scores.add(score);
    scores.sort((b, a) => a.compareTo(b)); // Urutkan dari skor tertinggi

    // Simpan hanya 20 skor tertinggi
    if (scores.length > 20) {
      scores = scores.sublist(0, 20);
    }

    await prefs.setStringList(
        'high_scores', scores.map((s) => s.toString()).toList());
  }

  /// Ambil daftar skor tertinggi
  Future<List<int>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('high_scores')?.map(int.parse).toList() ?? [];
  }

  // **Hapus semua skor**
  Future<void> clearHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('high_scores');

    state = state.copyWith();
  }
}
