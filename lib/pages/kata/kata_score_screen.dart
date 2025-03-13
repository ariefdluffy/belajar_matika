import 'package:belajar_matika/providers/kata/susun_kata_skor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KataScoreScreen extends ConsumerWidget {
  const KataScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = ref.watch(scoreSusunKataProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Skor Pemain"), automaticallyImplyLeading: false),
      body: scores.isEmpty
          ? const Center(child: Text("Belum ada skor"))
          : ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(score.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text("Skor: ${score.score}",
                      style: const TextStyle(fontSize: 16)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(scoreSusunKataProvider.notifier).clearScoresSusunKata();
        },
        tooltip: "Hapus Semua Skor",
        child: const Icon(Icons.delete),
      ),
    );
  }
}
