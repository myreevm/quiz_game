import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/app_texts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const questionOptions = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final settingsController = AppSettingsScope.of(context);
    final settings = settingsController.settings;
    final texts = AppTexts.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(texts.settingsTitle)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(texts.settingsDarkThemeTitle),
            subtitle: Text(texts.settingsDarkThemeSubtitle),
            value: settings.darkModeEnabled,
            onChanged: settingsController.setDarkModeEnabled,
          ),
          SwitchListTile(
            title: Text(texts.settingsSoundTitle),
            subtitle: Text(texts.settingsSoundSubtitle),
            value: settings.soundEnabled,
            onChanged: settingsController.setSoundEnabled,
          ),
          SwitchListTile(
            title: Text(texts.settingsShuffleQuestionsTitle),
            subtitle: Text(texts.settingsShuffleQuestionsSubtitle),
            value: settings.shuffleQuestions,
            onChanged: settingsController.setShuffleQuestions,
          ),
          SwitchListTile(
            title: Text(texts.settingsShuffleAnswersTitle),
            subtitle: Text(texts.settingsShuffleAnswersSubtitle),
            value: settings.shuffleAnswers,
            onChanged: settingsController.setShuffleAnswers,
          ),
          ListTile(
            title: Text(texts.settingsQuestionsPerRoundTitle),
            subtitle: Text(texts.settingsQuestionsPerRoundSubtitle),
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
          ListTile(
            title: Text(texts.settingsLanguageTitle),
            subtitle: Text(texts.settingsLanguageSubtitle),
            trailing: DropdownButton<AppLanguage>(
              value: settings.appLanguage,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                settingsController.setAppLanguage(value);
              },
              items: AppLanguage.values
                  .map(
                    (language) => DropdownMenuItem<AppLanguage>(
                      value: language,
                      child: Text(texts.languageName(language)),
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
