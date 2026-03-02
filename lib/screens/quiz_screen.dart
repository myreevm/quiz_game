import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/app_texts.dart';
import '../models/player_progress.dart';
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
  static const int _questionTimeLimitSec = 20;

  int questionIndex = 0;
  int score = 0;
  List<Question> questions = [];
  bool isLoading = true;
  bool hasLoadedData = false;

  bool _timerEnabledForRound = true;
  Timer? _questionTimer;
  int _secondsLeft = _questionTimeLimitSec;
  bool _isTimerPausedForHint = false;
  bool _isSubmittingAnswer = false;
  bool _hintUsedForCurrentQuestion = false;

  int _timeoutsInRound = 0;
  int _hintsUsedInRound = 0;
  Set<int> _visibleAnswerIndexes = <int>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (hasLoadedData) {
      return;
    }

    hasLoadedData = true;
    loadData();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    super.dispose();
  }

  Future<void> loadData() async {
    final appSettings = AppSettingsScope.of(context).settings;
    _timerEnabledForRound = appSettings.questionTimerEnabled;

    final loadedQuestions = await QuestionService.loadQuestions(
      country: widget.country,
      region: widget.region,
      category: widget.category,
      language: appSettings.appLanguage,
    );

    final random = Random();
    var preparedQuestions = loadedQuestions
        .map(
          (question) => Question(
            questionText: question.questionText,
            imageAsset: question.imageAsset,
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
      if (questions.isNotEmpty) {
        _resetCurrentQuestionState();
      }
    });

    if (questions.isNotEmpty) {
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    _questionTimer?.cancel();
    if (!_timerEnabledForRound || questions.isEmpty || _isSubmittingAnswer) {
      return;
    }

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isSubmittingAnswer || _isTimerPausedForHint) {
        return;
      }

      if (_secondsLeft <= 1) {
        setState(() {
          _secondsLeft = 0;
        });
        _submitAnswer(0, isTimeout: true);
        return;
      }

      setState(() {
        _secondsLeft -= 1;
      });
    });
  }

  void _pauseTimerForHint() {
    if (!_timerEnabledForRound || _isTimerPausedForHint) {
      return;
    }

    _questionTimer?.cancel();
    setState(() {
      _isTimerPausedForHint = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted || _isSubmittingAnswer) {
        return;
      }

      setState(() {
        _isTimerPausedForHint = false;
      });
      _startTimerIfNeeded();
    });
  }

  void _resetCurrentQuestionState() {
    final answerCount = questions[questionIndex].answers.length;
    _visibleAnswerIndexes = {
      for (var i = 0; i < answerCount; i++) i,
    };
    _hintUsedForCurrentQuestion = false;
    _isSubmittingAnswer = false;
    _isTimerPausedForHint = false;
    _secondsLeft = _questionTimeLimitSec;
  }

  Future<void> _submitAnswer(
    int answerScore, {
    bool isTimeout = false,
  }) async {
    if (_isSubmittingAnswer || !mounted) {
      return;
    }

    _isSubmittingAnswer = true;
    _questionTimer?.cancel();

    if (isTimeout) {
      _timeoutsInRound += 1;
    }

    score += answerScore;

    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex += 1;
        _resetCurrentQuestionState();
      });
      _startTimerIfNeeded();
      return;
    }

    final normalizedScore = _normalizedScore(score, questions.length);
    final progressController = PlayerProgressScope.of(context);
    final newlyUnlocked = progressController.recordRound(
      RoundRecord(
        country: widget.country,
        totalQuestions: questions.length,
        correctAnswers: normalizedScore,
        timeouts: _timeoutsInRound,
        timerWasEnabled: _timerEnabledForRound,
        hintsUsed: _hintsUsedInRound,
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: normalizedScore,
          total: questions.length,
          newlyUnlocked: newlyUnlocked,
        ),
      ),
    );
  }

  void _useHint() {
    if (questions.isEmpty || _isSubmittingAnswer) {
      return;
    }

    final texts = AppTexts.of(context);
    final currentQuestion = questions[questionIndex];

    if (_hintUsedForCurrentQuestion) {
      _showHintMessage(texts.quizHintAlreadyUsed);
      return;
    }

    final correctIndex = _correctAnswerIndex(currentQuestion);
    if (correctIndex == null) {
      _showHintMessage(texts.quizHintUnavailable);
      return;
    }

    final wrongIndexes = <int>[];
    for (var i = 0; i < currentQuestion.answers.length; i++) {
      if (i != correctIndex) {
        wrongIndexes.add(i);
      }
    }

    if (wrongIndexes.isEmpty) {
      _showHintMessage(texts.quizHintUnavailable);
      return;
    }

    final progressController = PlayerProgressScope.of(context);
    if (!progressController.tryConsumeHint()) {
      _showHintMessage(texts.quizHintNoBalance);
      return;
    }

    wrongIndexes.shuffle(Random());
    final keepWrong = wrongIndexes.first;

    setState(() {
      _hintUsedForCurrentQuestion = true;
      _hintsUsedInRound += 1;
      _visibleAnswerIndexes = {correctIndex, keepWrong};
    });

    _pauseTimerForHint();
  }

  int? _correctAnswerIndex(Question question) {
    if (question.answers.length < 2) {
      return null;
    }

    var bestIndex = 0;
    var bestScore = question.answers.first.score;
    for (var i = 1; i < question.answers.length; i++) {
      final score = question.answers[i].score;
      if (score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }

    final hasWrongAnswer =
        question.answers.any((answer) => answer.score < bestScore);
    if (!hasWrongAnswer) {
      return null;
    }

    return bestIndex;
  }

  int _normalizedScore(int rawScore, int totalQuestions) {
    if (rawScore < 0) {
      return 0;
    }
    if (rawScore > totalQuestions) {
      return totalQuestions;
    }
    return rawScore;
  }

  void _showHintMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final progressController = PlayerProgressScope.of(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return _QuizEmptyState(
        texts: texts,
        category: texts.categoryName(widget.category),
      );
    }

    final currentQuestion = questions[questionIndex];
    final progress = (questionIndex + 1) / questions.length;
    final colorScheme = Theme.of(context).colorScheme;
    final hintBalance = progressController.progress.hintBalance;

    final visibleAnswers = currentQuestion.answers.asMap().entries.where(
          (entry) => _visibleAnswerIndexes.contains(entry.key),
        );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(texts.categoryName(widget.category)),
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
                          texts: texts,
                          currentQuestion: questionIndex + 1,
                          totalQuestions: questions.length,
                          score: _normalizedScore(score, questions.length),
                          progress: progress,
                          timerEnabled: _timerEnabledForRound,
                          secondsLeft: _secondsLeft,
                          timerPausedForHint: _isTimerPausedForHint,
                          hintBalance: hintBalance,
                          onUseHintPressed: _useHint,
                        ),
                        const SizedBox(height: 14),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          child: _QuestionCard(
                            key: ValueKey(questionIndex),
                            text: currentQuestion.questionText,
                            imageAsset: currentQuestion.imageAsset,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          texts.quizSelectAnswer,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        ...visibleAnswers.map((entry) {
                          final optionIndex = entry.key;
                          final answer = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _AnswerCard(
                              optionIndex: optionIndex,
                              text: answer.text,
                              iconColor: _optionColor(optionIndex, colorScheme),
                              onTap: () => _submitAnswer(answer.score),
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
  final AppTexts texts;
  final int currentQuestion;
  final int totalQuestions;
  final int score;
  final double progress;
  final bool timerEnabled;
  final int secondsLeft;
  final bool timerPausedForHint;
  final int hintBalance;
  final VoidCallback onUseHintPressed;

  const _QuizProgressCard({
    required this.texts,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.score,
    required this.progress,
    required this.timerEnabled,
    required this.secondsLeft,
    required this.timerPausedForHint,
    required this.hintBalance,
    required this.onUseHintPressed,
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
                  texts.quizQuestionProgress(currentQuestion, totalQuestions),
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
                  texts.quizScoreLabel(score),
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (timerEnabled)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    timerPausedForHint
                        ? texts.quizTimerPausedLabel
                        : texts.quizTimerLabel(secondsLeft),
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: onUseHintPressed,
                style: FilledButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
                icon: const Icon(Icons.lightbulb_rounded, size: 18),
                label: Text(texts.quizHintButtonLabel(hintBalance)),
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
  final String? imageAsset;

  const _QuestionCard({
    super.key,
    required this.text,
    required this.imageAsset,
  });

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageAsset != null) ...[
              _QuestionImage(imageAsset: imageAsset!),
              const SizedBox(height: 14),
            ],
            Row(
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
          ],
        ),
      ),
    );
  }
}

class _QuestionImage extends StatefulWidget {
  final String imageAsset;

  const _QuestionImage({required this.imageAsset});

  @override
  State<_QuestionImage> createState() => _QuestionImageState();
}

class _QuestionImageState extends State<_QuestionImage> {
  bool _hasLoadError = false;

  @override
  void didUpdateWidget(covariant _QuestionImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageAsset != oldWidget.imageAsset) {
      _hasLoadError = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasLoadError) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      key: const ValueKey('quiz-question-image'),
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image(
          image: ExactAssetImage(widget.imageAsset),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || _hasLoadError) {
                return;
              }
              setState(() {
                _hasLoadError = true;
              });
            });
            return const SizedBox.shrink();
          },
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
  final AppTexts texts;
  final String category;

  const _QuizEmptyState({
    required this.texts,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(texts.quizScreenTitle)),
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
                      texts.quizEmptyTitle,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      texts.quizEmptyDescription(category),
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
                      label: Text(texts.backButton),
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
