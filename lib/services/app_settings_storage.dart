import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

class AppSettingsStorage {
  static const String _darkModeKey = 'settings.dark_mode_enabled';
  static const String _soundKey = 'settings.sound_enabled';
  static const String _shuffleQuestionsKey = 'settings.shuffle_questions';
  static const String _shuffleAnswersKey = 'settings.shuffle_answers';
  static const String _questionsPerRoundKey = 'settings.questions_per_round';
  static const String _languageKey = 'settings.app_language';

  static const Set<int> _allowedQuestionsPerRound = {5, 10, 15, 20};

  Future<AppSettings> load() async {
    const defaults = AppSettings();

    try {
      final prefs = await SharedPreferences.getInstance();

      final questionsPerRoundRaw =
          prefs.getInt(_questionsPerRoundKey) ?? defaults.questionsPerRound;
      final questionsPerRound =
          _allowedQuestionsPerRound.contains(questionsPerRoundRaw)
              ? questionsPerRoundRaw
              : defaults.questionsPerRound;

      final languageRaw = prefs.getString(_languageKey);
      final language = AppLanguage.values.firstWhere(
        (value) => value.name == languageRaw,
        orElse: () => defaults.appLanguage,
      );

      return AppSettings(
        darkModeEnabled:
            prefs.getBool(_darkModeKey) ?? defaults.darkModeEnabled,
        soundEnabled: prefs.getBool(_soundKey) ?? defaults.soundEnabled,
        shuffleQuestions:
            prefs.getBool(_shuffleQuestionsKey) ?? defaults.shuffleQuestions,
        shuffleAnswers:
            prefs.getBool(_shuffleAnswersKey) ?? defaults.shuffleAnswers,
        questionsPerRound: questionsPerRound,
        appLanguage: language,
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to load app settings: $error');
      debugPrintStack(stackTrace: stackTrace);
      return defaults;
    }
  }

  Future<void> save(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, settings.darkModeEnabled);
      await prefs.setBool(_soundKey, settings.soundEnabled);
      await prefs.setBool(_shuffleQuestionsKey, settings.shuffleQuestions);
      await prefs.setBool(_shuffleAnswersKey, settings.shuffleAnswers);
      await prefs.setInt(_questionsPerRoundKey, settings.questionsPerRound);
      await prefs.setString(_languageKey, settings.appLanguage.name);
    } catch (error, stackTrace) {
      debugPrint('Failed to save app settings: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
