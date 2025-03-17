import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

final wordProvider = StateNotifierProvider<GameController, GameState>((ref) {
  return GameController();
});

class GameState {
  final String word;
  final List<String> shuffledLetters;
  final List<String?> placedLetters;
  final int currentQuestion;
  final int maxQuestions;

  GameState({
    required this.word,
    required this.shuffledLetters,
    required this.placedLetters,
    required this.currentQuestion,
    this.maxQuestions = 10,
  });

  GameState copyWith({
    String? word,
    List<String>? shuffledLetters,
    List<String?>? placedLetters,
    int? currentQuestion,
    int? maxQuestions,
  }) {
    return GameState(
      word: word ?? this.word,
      shuffledLetters: shuffledLetters ?? this.shuffledLetters,
      placedLetters: placedLetters ?? this.placedLetters,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      maxQuestions: maxQuestions ?? this.maxQuestions,
    );
  }
}

class GameController extends StateNotifier<GameState> {
  GameController() : super(_generateNewWord(1));

  static List<String> wordList = [
    // Binatang
    "KUCING", "IKAN", "BURUNG", "GAJAH", "ULAR", "BEBEK", "AYAM",
    "SAPI", "KERBAU",
    "KAMBING", "RUSA", "KUDA", "TIKUS", "MONYET", "KUDA", "BANTEN",
    "KUPU", "LEBAH",
    "CICAK", "TOKEK", "CACING", "KURA", "SEMUT", "KODOK", "LUMBA", "HIU",
    "PANDA", "MERAK",
    "PITON", "NAGA", "BELUT", "KECIL", "RUBAH", "KOALA", "ZEBRA",

    // Tanaman
    "BUNGA", "MELATI", "ROSE", "DAUN", "PISANG", "MANGGA", "JAGUNG", "KELAPA",
    "PADI", "GANDUM",
    "POHON", "AKAR", "SELAI", "TOMAT", "CABAI", "BAWANG", "JAHE", "LADA",
    "TERONG", "KACANG",
    "TEBU", "TEH", "ANGGUR", "RAMBU", "NANAS", "DURIAN", "SALAK", "JAMBU",
    "KOPI", "KAKAO",
    "ASAM", "BENGK", "JATI", "CEMAR", "MAWAR", "FLORA", "SERAI",
    "BUNGA",

    // Alam
    "GUNUNG", "LAUT", "DANAU", "SUNGAI", "TANAH", "BATU", "AWAN", "HUJAN",
    "PETIR", "KABUT",
    "EMBUN", "OMBAK", "PASIR", "BUKIT", "LEMBAH", "HUTAN", "TEBING",
    "SALJU", "ANGIN",
    "BULAN", "BINTANG", "CAHAYA", "TITIK", "PANTAI", "CERAH",
    "KAPUR", "TAMAN", "SEJUK", "SURYA", "MERAH",
    "SUMUR"
  ];

  static GameState _generateNewWord(int questionNumber) {
    String word = wordList[Random().nextInt(wordList.length)];
    List<String> shuffled = List.from(word.split(''))..shuffle();
    return GameState(
      word: word,
      shuffledLetters: shuffled,
      placedLetters: List.filled(word.length, null),
      currentQuestion: questionNumber,
    );
  }

  void placeLetter(int index, String letter) {
    List<String?> newPlacedLetters = List.from(state.placedLetters);
    newPlacedLetters[index] = letter;
    List<String> newShuffledLetters = List.from(state.shuffledLetters)
      ..remove(letter);

    state = state.copyWith(
      placedLetters: newPlacedLetters,
      shuffledLetters: newShuffledLetters,
    );
  }

  bool checkWin() {
    return state.placedLetters.join() == state.word;
  }

  // void nextQuestion() {
  //   if (state.currentQuestion < 5) {
  //     state = _generateNewWord(state.currentQuestion + 1);
  //   }
  // }
  void nextQuestion() {
    if (state.currentQuestion < state.maxQuestions) {
      GameState newGameState = _generateNewWord(state.currentQuestion + 1);

      state = state.copyWith(
        currentQuestion: state.currentQuestion + 1,
        word: newGameState.word,
        shuffledLetters: newGameState.shuffledLetters,
        placedLetters: List.filled(
            newGameState.word.length, null), // Reset sesuai kata baru
      );
    }
  }

  void resetGame() {
    state = _generateNewWord(1);
  }
}
