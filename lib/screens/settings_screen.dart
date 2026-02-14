import 'package:flutter/material.dart';

import '../models/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const questionOptions = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final settingsController = AppSettingsScope.of(context);
    final settings = settingsController.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Тёмная тема'),
            subtitle: const Text('Включить тёмное оформление приложения'),
            value: settings.darkModeEnabled,
            onChanged: settingsController.setDarkModeEnabled,
          ),
          SwitchListTile(
            title: const Text('Звук'),
            subtitle: const Text('Включить звуковые эффекты'),
            value: settings.soundEnabled,
            onChanged: settingsController.setSoundEnabled,
          ),
          SwitchListTile(
            title: const Text('Перемешивать вопросы'),
            subtitle: const Text('Менять порядок вопросов перед началом игры'),
            value: settings.shuffleQuestions,
            onChanged: settingsController.setShuffleQuestions,
          ),
          SwitchListTile(
            title: const Text('Перемешивать варианты ответов'),
            subtitle:
                const Text('Менять порядок ответов внутри каждого вопроса'),
            value: settings.shuffleAnswers,
            onChanged: settingsController.setShuffleAnswers,
          ),
          ListTile(
            title: const Text('Вопросов за раунд'),
            subtitle: const Text('Сколько вопросов показывать за одну игру'),
            trailing: DropdownButton<int>(
              value: settings.questionsPerRound,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                settingsController.setQuestionsPerRound(value);
              },
              items: questionOptions
                  .map(
                    (count) => DropdownMenuItem<int>(
                      value: count,
                      child: Text('$count'),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
