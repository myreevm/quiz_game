import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  String get resultMessage {
    final percent = score / total;

    if (percent >= 0.9) {
      return 'Отличный результат! Вы настоящий эксперт 🎉';
    }
    if (percent >= 0.7) {
      return 'Очень хорошо! Ещё немного и будет максимум 👏';
    }
    if (percent >= 0.5) {
      return 'Неплохо! Попробуйте снова, чтобы улучшить результат 👍';
    }
    return 'Хорошая попытка! В следующий раз будет лучше 💪';
  }

  @override
  Widget build(BuildContext context) {
    final percent = ((score / total) * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Результат')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ваш результат: $score из $total',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                '$percent%',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              Text(
                resultMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('В главное меню'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
