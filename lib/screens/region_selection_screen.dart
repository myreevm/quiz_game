import 'package:flutter/material.dart';
import 'category_selection_screen.dart';

class RegionSelectionScreen extends StatelessWidget {
  final String country;

  const RegionSelectionScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор региона')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 КНОПКА "ВСЯ СТРАНА"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategorySelectionScreen(
                      country: country,
                      region: null, // вот тут мы передаём null
                    ),
                  ),
                );
              },
              child: const Text('Вся страна'),
            ),

            const SizedBox(height: 12),

            // 🔹 ПРИМЕР РЕГИОНОВ
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategorySelectionScreen(
                      country: country,
                      region: 'yakutia',
                    ),
                  ),
                );
              },
              child: const Text('Якутия'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategorySelectionScreen(
                      country: country,
                      region: 'dagestan',
                    ),
                  ),
                );
              },
              child: const Text('Дагестан'),
            ),
          ],
        ),
      ),
    );
  }
}
