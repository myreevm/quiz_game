import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  final String country;
  final String? region;

  const CategorySelectionScreen({
    super.key,
    required this.country,
    required this.region,
  });

  final categories = const {
    'famous_people': 'Известные личности',
    'history': 'История',
    'movies': 'Фильмы',
    'music': 'Музыка',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Категории: $region')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: categories.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        country: country,
                        region: region,
                        category: entry.key,
                      ),
                    ),
                  );
                },
                child: Text(entry.value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
