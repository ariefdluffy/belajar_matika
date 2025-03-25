import 'package:belajar_matika/models/question_model.dart';

class GameState {
  final int score;
  final int mistakes;
  final int timeLeft;
  final bool isGameOver;
  final Question currentQuestion;
  final int questionCount;

  GameState({
    required this.score,
    required this.mistakes,
    required this.timeLeft,
    required this.isGameOver,
    required this.currentQuestion,
    required this.questionCount,
  });

  GameState copyWith({
    int? score,
    int? mistakes,
    int? timeLeft,
    bool? isGameOver,
    Question? currentQuestion,
    int? questionCount,
  }) {
    return GameState(
      score: score ?? this.score,
      mistakes: mistakes ?? this.mistakes,
      timeLeft: timeLeft ?? this.timeLeft,
      isGameOver: isGameOver ?? this.isGameOver,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      questionCount: questionCount ?? this.questionCount,
    );
  }
}
