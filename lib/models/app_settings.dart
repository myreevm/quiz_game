import 'package:flutter/material.dart';

enum AppLanguage {
  english,
  russian,
  yakut,
}

class AppSettings {
  final bool darkModeEnabled;
  final bool soundEnabled;
  final bool shuffleQuestions;
  final bool shuffleAnswers;
  final int questionsPerRound;
  final AppLanguage appLanguage;

  const AppSettings({
    this.darkModeEnabled = false,
    this.soundEnabled = true,
    this.shuffleQuestions = true,
    this.shuffleAnswers = true,
    this.questionsPerRound = 10,
    this.appLanguage = AppLanguage.russian,
  });

  AppSettings copyWith({
    bool? darkModeEnabled,
    bool? soundEnabled,
    bool? shuffleQuestions,
    bool? shuffleAnswers,
    int? questionsPerRound,
    AppLanguage? appLanguage,
  }) {
    return AppSettings(
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      shuffleAnswers: shuffleAnswers ?? this.shuffleAnswers,
      questionsPerRound: questionsPerRound ?? this.questionsPerRound,
      appLanguage: appLanguage ?? this.appLanguage,
    );
  }
}

class AppSettingsController extends ChangeNotifier {
  AppSettings _settings = const AppSettings();

  AppSettings get settings => _settings;

  void setDarkModeEnabled(bool enabled) {
    _settings = _settings.copyWith(darkModeEnabled: enabled);
    notifyListeners();
  }

  void setSoundEnabled(bool enabled) {
    _settings = _settings.copyWith(soundEnabled: enabled);
    notifyListeners();
  }

  void setShuffleQuestions(bool enabled) {
    _settings = _settings.copyWith(shuffleQuestions: enabled);
    notifyListeners();
  }

  void setShuffleAnswers(bool enabled) {
    _settings = _settings.copyWith(shuffleAnswers: enabled);
    notifyListeners();
  }

  void setQuestionsPerRound(int value) {
    _settings = _settings.copyWith(questionsPerRound: value);
    notifyListeners();
  }

  void setAppLanguage(AppLanguage language) {
    _settings = _settings.copyWith(appLanguage: language);
    notifyListeners();
  }
}

class AppSettingsScope extends InheritedNotifier<AppSettingsController> {
  const AppSettingsScope({
    super.key,
    required AppSettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppSettingsController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope is not found in widget tree.');
    return scope!.notifier!;
  }
}
