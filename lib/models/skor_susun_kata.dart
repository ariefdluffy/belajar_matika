class ScoreSusunKata {
  final String name;
  final int score;

  ScoreSusunKata({required this.name, required this.score});

  Map<String, dynamic> toJson() => {"name": name, "score": score};

  factory ScoreSusunKata.fromJson(Map<String, dynamic> json) {
    return ScoreSusunKata(name: json['name'], score: json['score']);
  }
}
