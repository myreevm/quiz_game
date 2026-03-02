class Question {
  final String questionText;
  final String? imageAsset;
  final List<Answer> answers;

  Question({
    required this.questionText,
    required this.answers,
    this.imageAsset,
  });
}

class Answer {
  final String text;
  final int score;

  Answer({required this.text, required this.score});
}
