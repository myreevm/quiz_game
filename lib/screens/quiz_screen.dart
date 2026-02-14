import 'dart:math';

import 'package:flutter/material.dart';

import '../models/app_settings.dart';
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
  bool hasLoadedData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (hasLoadedData) {
      return;
    }

    hasLoadedData = true;
    loadData();
  }

  Future<void> loadData() async {
    final appSettings = AppSettingsScope.of(context).settings;
    final loadedQuestions = await QuestionService.loadQuestions(
      country: widget.country,
      region: widget.region,
      category: widget.category,
    );

    final random = Random();
    var preparedQuestions = loadedQuestions
        .map(
          (question) => Question(
            questionText: question.questionText,
            answers: appSettings.shuffleAnswers
                ? ([...question.answers]..shuffle(random))
                : [...question.answers],
          ),
        )
        .toList();

    if (appSettings.shuffleQuestions) {
      preparedQuestions.shuffle(random);
    }

    if (preparedQuestions.length > appSettings.questionsPerRound) {
      preparedQuestions =
          preparedQuestions.take(appSettings.questionsPerRound).toList();
    }

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
      return _QuizEmptyState(category: _categoryTitle(widget.category));
    }

    final currentQuestion = questions[questionIndex];
    final progress = (questionIndex + 1) / questions.length;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_categoryTitle(widget.category)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.6),
              colorScheme.surface,
              colorScheme.secondaryContainer.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding =
                  constraints.maxWidth > 700 ? 40.0 : 16.0;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  14,
                  horizontalPadding,
                  20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _QuizProgressCard(
                          currentQuestion: questionIndex + 1,
                          totalQuestions: questions.length,
                          score: score,
                          progress: progress,
                        ),
                        const SizedBox(height: 14),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          child: _QuestionCard(
                            key: ValueKey(questionIndex),
                            text: currentQuestion.questionText,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Выберите один вариант ответа',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        ...currentQuestion.answers.asMap().entries.map((entry) {
                          final optionIndex = entry.key;
                          final answer = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _AnswerCard(
                              optionIndex: optionIndex,
                              text: answer.text,
                              iconColor: _optionColor(optionIndex, colorScheme),
                              onTap: () => answerQuestion(answer.score),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _categoryTitle(String category) {
    const categories = {
      'famous_people': 'Известные личности',
      'history': 'История',
      'movies': 'Фильмы',
      'music': 'Музыка',
    };

    return categories[category] ?? category.toUpperCase();
  }

  Color _optionColor(int index, ColorScheme colorScheme) {
    switch (index % 4) {
      case 0:
        return colorScheme.primary;
      case 1:
        return colorScheme.secondary;
      case 2:
        return colorScheme.tertiary;
      default:
        return colorScheme.error;
    }
  }
}

class _QuizProgressCard extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int score;
  final double progress;

  const _QuizProgressCard({
    required this.currentQuestion,
    required this.totalQuestions,
    required this.score,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.9),
            colorScheme.secondary.withValues(alpha: 0.82),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Вопрос $currentQuestion из $totalQuestions',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Очки: $score',
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String text;

  const _QuestionCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.14),
              ),
              child: Icon(Icons.quiz_rounded, color: colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: textTheme.titleLarge?.copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final int optionIndex;
  final String text;
  final Color iconColor;
  final VoidCallback onTap;

  const _AnswerCard({
    required this.optionIndex,
    required this.text,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final label = String.fromCharCode(65 + optionIndex);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.55),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withValues(alpha: 0.16),
                ),
                child: Text(
                  label,
                  style: textTheme.titleMedium?.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: textTheme.titleMedium?.copyWith(
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizEmptyState extends StatelessWidget {
  final String category;

  const _QuizEmptyState({required this.category});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Викторина')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.12),
                      ),
                      child: Icon(
                        Icons.hourglass_empty_rounded,
                        size: 34,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Пока нет вопросов',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Для категории "$category" вопросы ещё не добавлены. '
                      'Попробуйте другую категорию или регион.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Вернуться назад'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
