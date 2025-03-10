import 'package:belajar_matika/providers/ads_provider.dart';
import 'package:belajar_matika/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ScoreScreen extends ConsumerWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getScore = ref.read(gameProvider.notifier).getHighScores();

    return Scaffold(
      appBar: AppBar(title: const Text("Papan Skor")),
      body: FutureBuilder<List<int>>(
        future: ref.read(gameProvider.notifier).getHighScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final scores = snapshot.data!;
          final bannerAd = ref.watch(bannerAdProviderNew);

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
                  padding: const EdgeInsets.all(16),
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text("${index + 1}")),
                        title: Text("Skor: ${scores[index]}"),
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
