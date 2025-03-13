import 'package:belajar_matika/providers/ads_provider.dart';
import 'package:belajar_matika/providers/matika/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, String>>> getHighScores() async {
  final prefs = await SharedPreferences.getInstance();
  final scores = prefs.getStringList('high_scores') ?? [];
  final usernames = prefs.getStringList('usernames') ?? []; // Ambil username

  List<Map<String, String>> highScores = [];

  for (int i = 0; i < scores.length; i++) {
    highScores.add({
      'username': i < usernames.length ? usernames[i] : 'Guest',
      'score': scores[i],
    });
  }

  return highScores;
}

class ScoreScreen extends ConsumerWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getScore = ref.read(gameProvider.notifier).getHighScores();

    final bannerAd = ref.watch(bannerAdProviderNew);

    return Scaffold(
      appBar: AppBar(title: const Text("Papan Skor")),
      body: FutureBuilder<List<Map<String, String>>>(
        future: getHighScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final highScores = snapshot.data!;

          if (highScores.isEmpty) {
            return const Center(child: Text("Belum ada skor tersimpan"));
          }

          return Column(
            children: [
              if (bannerAd != null &&
                  bannerAd.responseInfo !=
                      null) // 🔹 Menampilkan Banner Ads jika berhasil dimuat
                SizedBox(
                  height: bannerAd.size.height.toDouble(),
                  width: bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: highScores.length,
                  itemBuilder: (context, index) {
                    final scoreData = highScores[index];
                    return Card(
                      child: ListTile(
                        title: Text("Nama: ${highScores[index]['username']}",
                            style: const TextStyle(fontSize: 18)),
                        subtitle: Text("🏆 Skor: ${scoreData['score']}",
                            style: const TextStyle(fontSize: 16)),
                        leading: CircleAvatar(
                          child: Text("${index + 1}"),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(gameProvider.notifier).clearHighScores();
                  ref.invalidate(gameProvider); // Refresh UI agar skor terhapus
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Papan skor berhasil dihapus")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Hapus Papan Skor"),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
