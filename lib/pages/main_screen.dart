import 'package:belajar_matika/pages/dashboard.dart';
import 'package:belajar_matika/pages/matika/home_screen.dart';
import 'package:belajar_matika/providers/nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'matika/game_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider); // Pantau indeks

    final List<Widget> screens = [
      const HomeScreen(), // Halaman Dashboard
      const GameScreen(), // Halaman Game
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).setIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Tebak Skor",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: "Game",
          ),
        ],
      ),
    );
  }
}
