import 'package:flutter/material.dart';
import 'country_selection_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'dart:io';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  Widget menuButton(BuildContext context, String title, Widget screen) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главное меню')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            menuButton(context, 'Играть', const CountrySelectionScreen()),
            menuButton(context, 'Настройки', const SettingsScreen()),
            menuButton(context, 'Об игре', const AboutScreen()),
            ElevatedButton(
              onPressed: () => exit(0),
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
