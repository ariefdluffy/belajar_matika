import 'package:belajar_matika/models/skor_susun_kata.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final scoreSusunKataProvider =
    StateNotifierProvider<ScoreSusunKataController, List<ScoreSusunKata>>(
        (ref) {
  return ScoreSusunKataController();
});

class ScoreSusunKataController extends StateNotifier<List<ScoreSusunKata>> {
  ScoreSusunKataController() : super([]) {
    loadScoresSusunKata();
  }

  Future<void> loadScoresSusunKata() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresJson = prefs.getString('ScoreSusunKata');
    if (scoresJson != null) {
      final List<dynamic> decoded = jsonDecode(scoresJson);
      state = decoded.map((e) => ScoreSusunKata.fromJson(e)).toList();
    }
  }

  Future<void> addScoreSusunKata(String name, int score) async {
    final newScore = ScoreSusunKata(name: name, score: score);
    state = [...state, newScore];

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'ScoreSusunKata', jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  Future<void> clearScoresSusunKata() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ScoreSusunKata');
    state = [];
  }
}
