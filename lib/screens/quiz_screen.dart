import 'dart:math';

import 'package:flutter/material.dart';

import '../models/question.dart';
import '../services/question_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String country;
  final String? region;
  final String category;

  const QuizScreen({
    super.key,
    required this.country,
    required this.region,
    required this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  int score = 0;
  List<Question> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final loadedQuestions = await QuestionService.loadQuestions(
      country: widget.country,
      region: widget.region,
      category: widget.category,
    );

    final random = Random();
    final shuffledQuestions = [...loadedQuestions]..shuffle(random);
    final preparedQuestions = shuffledQuestions
        .map(
          (question) => Question(
            questionText: question.questionText,
            answers: [...question.answers]..shuffle(random),
          ),
        )
        .toList();

    if (!mounted) {
      return;
    }

    setState(() {
      questions = preparedQuestions;
      isLoading = false;
    });
  }

  void answerQuestion(int answerScore) {
    score += answerScore;

    if (questionIndex < questions.length - 1) {
      setState(() => questionIndex++);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: score,
          total: questions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Викторина')),
        body: const Center(
          child: Text(
            'В этой категории пока нет вопросов',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final currentQuestion = questions[questionIndex];
    final progress = (questionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.toUpperCase())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Вопрос ${questionIndex + 1} из ${questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 20),
            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ...currentQuestion.answers.map(
              (answer) => Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () => answerQuestion(answer.score),
                  child: Text(answer.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
