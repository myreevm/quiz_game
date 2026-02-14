import 'package:flutter/material.dart';

import '../models/app_texts.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final percent = ((score / total) * 100).round();
    final ratio = score / total;

    return Scaffold(
      appBar: AppBar(title: Text(texts.resultTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                texts.resultScoreText(score, total),
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
                texts.resultMessageForPercent(ratio),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(texts.resultToMainMenu),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
