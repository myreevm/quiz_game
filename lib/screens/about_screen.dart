import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Об игре')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Это викторина на Flutter.\n\n'
          'Выбирайте режим и проверяйте свои знания!\n'
          'Версия 1.0',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
