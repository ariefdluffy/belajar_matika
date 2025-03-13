import 'dart:async';
import 'package:belajar_matika/models/question_model.dart';
import 'package:belajar_matika/providers/matika/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/game_state.dart';

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

  void endGame() {
    _timer?.cancel();
    String username = ref.read(userProvider); // Ambil nama pengguna
    state = state.copyWith(isGameOver: true);
    saveScore(username, state.score); // Urutan parameter diperbaiki
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft <= 0) {
        endGame();
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
      endGame();
    } else {
      state = state.copyWith(currentQuestion: Question.generate());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Simpan skor ke SharedPreferences dengan hanya 20 skor tertinggi
  Future<void> saveScore(String username, int score) async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil daftar skor dan username yang tersimpan
    List<String> scores = prefs.getStringList('high_scores') ?? [];
    List<String> usernames = prefs.getStringList('usernames') ?? [];

    // Pastikan jumlah skor dan usernames selalu sama
    if (scores.length != usernames.length) {
      scores.clear();
      usernames.clear();
    }

    // Tambahkan skor dan username baru
    scores.add(score.toString());
    usernames.add(username);

    // Urutkan skor dari tertinggi ke terendah
    List<Map<String, String>> sortedScores = [];
    for (int i = 0; i < scores.length; i++) {
      sortedScores.add({'username': usernames[i], 'score': scores[i]});
    }

    sortedScores.sort(
        (b, a) => int.parse(a['score']!).compareTo(int.parse(b['score']!)));

    // Simpan hanya 20 skor tertinggi
    if (sortedScores.length > 20) {
      sortedScores = sortedScores.sublist(0, 20);
    }

    // Simpan kembali ke SharedPreferences
    await prefs.setStringList(
        'high_scores', sortedScores.map((e) => e['score']!).toList());
    await prefs.setStringList(
        'usernames', sortedScores.map((e) => e['username']!).toList());
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
