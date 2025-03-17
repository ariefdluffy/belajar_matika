import 'package:belajar_matika/pages/kata/about_kata_screen.dart';
import 'package:belajar_matika/pages/kata/kata_score_screen.dart';
import 'package:belajar_matika/pages/kata/kata_game_screen.dart';
import 'package:belajar_matika/pages/matika/about_screen.dart';
import 'package:belajar_matika/providers/ads_provider.dart';
import 'package:belajar_matika/providers/nav_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeKataScreen extends ConsumerStatefulWidget {
  const HomeKataScreen({super.key});

  @override
  ConsumerState<HomeKataScreen> createState() => _HomeScreenKataState();
}

class _HomeScreenKataState extends ConsumerState<HomeKataScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navigationProvider);

    final screens = [
      const KataGameScreen(),
      const KataScoreScreen(),
      const AboutKataScreen(),
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
              icon: Icon(Icons.videogame_asset), label: "Susun Kata"),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: "Skor"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_sharp), label: "About"),
        ],
      ),
    );
  }
}
