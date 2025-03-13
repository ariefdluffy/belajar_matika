import 'package:flutter_riverpod/flutter_riverpod.dart';

// final navigationProvider = StateProvider<int>((ref) => 0);

// StateNotifier untuk mengelola indeks bottom navigation
class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

// Provider untuk membaca dan mengubah indeks bottom navigation
final navigationProvider =
    StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});
