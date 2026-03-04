class Question {
  final String questionText;
  final String? imageAsset;
  final String? explanationText;
  final List<Answer> answers;

  Question({
    required this.questionText,
    required this.answers,
    this.imageAsset,
    this.explanationText,
  });
}

class Answer {
  final String text;
  final int score;

  Answer({required this.text, required this.score});
}
