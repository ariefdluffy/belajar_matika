import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorage {
  static const String _keyScores = "high_scores";

  /// Simpan skor baru dan hanya menyimpan 20 skor tertinggi
  static Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> scores =
        prefs.getStringList(_keyScores)?.map(int.parse).toList() ?? [];

    // Tambahkan skor baru dan urutkan
    scores.add(score);
    scores.sort((b, a) => a.compareTo(b)); // Urutkan dari besar ke kecil

    // Simpan hanya 20 skor terbaik
    if (scores.length > 20) {
      scores = scores.sublist(0, 20);
    }

    await prefs.setStringList(
        _keyScores, scores.map((e) => e.toString()).toList());
  }

  /// Ambil daftar 20 skor tertinggi
  static Future<List<int>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    List<int> scores =
        prefs.getStringList(_keyScores)?.map(int.parse).toList() ?? [];
    return scores;
  }
}
