import 'package:belajar_matika/pages/about_screen.dart';
import 'package:belajar_matika/pages/score_screen.dart';
import 'package:belajar_matika/providers/ads_provider.dart';
import 'package:belajar_matika/providers/nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);

    final screens = [
      const GameScreen(),
      const ScoreScreen(),
      const AboutScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 1) {
            ref
                .read(adProvider)
                .showInterstitialAd(); // Tampilkan iklan sebelum ke "About"
          }
          ref.read(navigationProvider.notifier).state = index; // Update halaman
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset), label: "Game"),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: "Skor"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_sharp), label: "About"),
        ],
      ),
    );
  }
}
