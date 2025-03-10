import 'dart:math';

enum Operation { addition, subtraction }

class Question {
  final String question;
  final int answer;
  final List<int> options;

  Question(
      {required this.question, required this.answer, required this.options});

  // Fungsi untuk membuat soal secara acak (penjumlahan atau pengurangan)
  static Question generate() {
    Random random = Random();
    int num1 = random.nextInt(20) + 1; // angka 1-20
    int num2 = random.nextInt(20) + 1;
    Operation operation =
        Operation.values[random.nextInt(Operation.values.length)];

    int correctAnswer;
    String questionText;

    if (operation == Operation.addition) {
      correctAnswer = num1 + num2;
      questionText = "$num1 + $num2 = ?";
    } else {
      // Pastikan hasil pengurangan tidak negatif
      if (num1 < num2) {
        int temp = num1;
        num1 = num2;
        num2 = temp;
      }
      correctAnswer = num1 - num2;
      questionText = "$num1 - $num2 = ?";
    }

    List<int> options = _generateOptions(correctAnswer);

    return Question(
      question: questionText,
      answer: correctAnswer,
      options: options,
    );
  }

  // Fungsi untuk membuat pilihan jawaban unik (tidak ada yang sama)
  static List<int> _generateOptions(int correctAnswer) {
    Random random = Random();
    Set<int> optionsSet = {correctAnswer};

    while (optionsSet.length < 4) {
      int wrongAnswer = correctAnswer + random.nextInt(10) - 5;

      // Pastikan jawaban salah unik dan tidak negatif
      if (wrongAnswer != correctAnswer && wrongAnswer >= 0) {
        optionsSet.add(wrongAnswer);
      }
    }

    List<int> options = optionsSet.toList();
    options.shuffle();
    return options;
  }
}
