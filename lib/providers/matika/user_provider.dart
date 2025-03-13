import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// StateProvider untuk menyimpan nama pengguna
final userProvider = StateProvider<String>((ref) => '');

// Fungsi untuk menyimpan nama pengguna ke lokal
Future<void> saveScore(String username, int score) async {
  final prefs = await SharedPreferences.getInstance();

  // Ambil skor dan username yang sudah tersimpan
  List<String> scores = prefs.getStringList('high_scores') ?? [];
  List<String> usernames = prefs.getStringList('usernames') ?? [];

  // Simpan skor dan username baru
  scores.add(score.toString());
  usernames.add(username);

  // Urutkan skor dari yang tertinggi
  List<Map<String, String>> sortedScores = [];
  for (int i = 0; i < scores.length; i++) {
    sortedScores.add({'username': usernames[i], 'score': scores[i]});
  }

  sortedScores
      .sort((b, a) => int.parse(a['score']!).compareTo(int.parse(b['score']!)));

  // Hanya simpan 20 skor tertinggi
  if (sortedScores.length > 20) {
    sortedScores = sortedScores.sublist(0, 20);
  }

  // Simpan kembali ke SharedPreferences
  prefs.setStringList(
      'high_scores', sortedScores.map((e) => e['score']!).toList());
  prefs.setStringList(
      'usernames', sortedScores.map((e) => e['username']!).toList());
}

// Fungsi untuk mengambil nama pengguna dari lokal
Future<void> loadUserName(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('user_name') ?? '';
  ref.read(userProvider.notifier).state = name;
}
