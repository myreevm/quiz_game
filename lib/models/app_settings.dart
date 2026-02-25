import 'dart:async';

import 'package:flutter/material.dart';

enum AppLanguage {
  english,
  russian,
  yakut,
}

class AppSettings {
  final bool darkModeEnabled;
  final bool soundEnabled;
  final bool questionTimerEnabled;
  final bool shuffleQuestions;
  final bool shuffleAnswers;
  final int questionsPerRound;
  final AppLanguage appLanguage;

  const AppSettings({
    this.darkModeEnabled = false,
    this.soundEnabled = true,
    this.questionTimerEnabled = true,
    this.shuffleQuestions = true,
    this.shuffleAnswers = true,
    this.questionsPerRound = 10,
    this.appLanguage = AppLanguage.russian,
  });

  AppSettings copyWith({
    bool? darkModeEnabled,
    bool? soundEnabled,
    bool? questionTimerEnabled,
    bool? shuffleQuestions,
    bool? shuffleAnswers,
    int? questionsPerRound,
    AppLanguage? appLanguage,
  }) {
    return AppSettings(
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      questionTimerEnabled: questionTimerEnabled ?? this.questionTimerEnabled,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      shuffleAnswers: shuffleAnswers ?? this.shuffleAnswers,
      questionsPerRound: questionsPerRound ?? this.questionsPerRound,
      appLanguage: appLanguage ?? this.appLanguage,
    );
  }
}

class AppSettingsController extends ChangeNotifier {
  final Future<void> Function(AppSettings settings)? _onSettingsChanged;
  AppSettings _settings;

  AppSettingsController({
    AppSettings initialSettings = const AppSettings(),
    Future<void> Function(AppSettings settings)? onSettingsChanged,
  })  : _settings = initialSettings,
        _onSettingsChanged = onSettingsChanged;

  AppSettings get settings => _settings;

  void setDarkModeEnabled(bool enabled) {
    _updateSettings(_settings.copyWith(darkModeEnabled: enabled));
  }

  void setSoundEnabled(bool enabled) {
    _updateSettings(_settings.copyWith(soundEnabled: enabled));
  }

  void setQuestionTimerEnabled(bool enabled) {
    _updateSettings(_settings.copyWith(questionTimerEnabled: enabled));
  }

  void setShuffleQuestions(bool enabled) {
    _updateSettings(_settings.copyWith(shuffleQuestions: enabled));
  }

  void setShuffleAnswers(bool enabled) {
    _updateSettings(_settings.copyWith(shuffleAnswers: enabled));
  }

  void setQuestionsPerRound(int value) {
    _updateSettings(_settings.copyWith(questionsPerRound: value));
  }

  void setAppLanguage(AppLanguage language) {
    _updateSettings(_settings.copyWith(appLanguage: language));
  }

  void _updateSettings(AppSettings next) {
    if (_isSameSettings(next, _settings)) {
      return;
    }

    _settings = next;
    notifyListeners();
    unawaited(_onSettingsChanged?.call(_settings));
  }

  bool _isSameSettings(AppSettings a, AppSettings b) {
    return a.darkModeEnabled == b.darkModeEnabled &&
        a.soundEnabled == b.soundEnabled &&
        a.questionTimerEnabled == b.questionTimerEnabled &&
        a.shuffleQuestions == b.shuffleQuestions &&
        a.shuffleAnswers == b.shuffleAnswers &&
        a.questionsPerRound == b.questionsPerRound &&
        a.appLanguage == b.appLanguage;
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
