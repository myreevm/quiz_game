import 'dart:async';

import 'package:flutter/material.dart';

enum AchievementId {
  firstRound,
  fiveRounds,
  twentyRounds,
  perfectRound,
  accuracyMaster,
  worldExplorer,
  hintTactician,
  speedClean,
}

enum DailyHintClaimResult {
  alreadyClaimed,
  granted,
  capped,
}

class CountryProgress {
  final int rounds;
  final int questions;
  final int correct;
  final Set<AchievementId> unlockedAchievements;

  CountryProgress({
    this.rounds = 0,
    this.questions = 0,
    this.correct = 0,
    Set<AchievementId>? unlockedAchievements,
  }) : unlockedAchievements =
            Set<AchievementId>.from(unlockedAchievements ?? const {});

  CountryProgress copyWith({
    int? rounds,
    int? questions,
    int? correct,
    Set<AchievementId>? unlockedAchievements,
  }) {
    return CountryProgress(
      rounds: rounds ?? this.rounds,
      questions: questions ?? this.questions,
      correct: correct ?? this.correct,
      unlockedAchievements: unlockedAchievements ??
          Set<AchievementId>.from(this.unlockedAchievements),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rounds': rounds,
      'questions': questions,
      'correct': correct,
      'unlockedAchievements':
          unlockedAchievements.map((value) => value.name).toList(),
    };
  }

  static CountryProgress fromJson(Map<String, dynamic> json) {
    final rawAchievements = json['unlockedAchievements'];
    final parsedAchievements = <AchievementId>{};

    if (rawAchievements is List) {
      for (final raw in rawAchievements) {
        final parsed = _achievementFromName(raw?.toString());
        if (parsed != null) {
          parsedAchievements.add(parsed);
        }
      }
    }

    return CountryProgress(
      rounds: _parseInt(json['rounds']) ?? 0,
      questions: _parseInt(json['questions']) ?? 0,
      correct: _parseInt(json['correct']) ?? 0,
      unlockedAchievements: parsedAchievements,
    );
  }
}

class PlayerProgress {
  final int totalRounds;
  final int totalQuestions;
  final int totalCorrect;
  final int perfectRounds;
  final int totalHintsUsed;
  final int hintBalance;
  final String? lastDailyHintDate;
  final Map<String, CountryProgress> countries;

  const PlayerProgress({
    this.totalRounds = 0,
    this.totalQuestions = 0,
    this.totalCorrect = 0,
    this.perfectRounds = 0,
    this.totalHintsUsed = 0,
    this.hintBalance = 0,
    this.lastDailyHintDate,
    this.countries = const {},
  });

  PlayerProgress copyWith({
    int? totalRounds,
    int? totalQuestions,
    int? totalCorrect,
    int? perfectRounds,
    int? totalHintsUsed,
    int? hintBalance,
    String? lastDailyHintDate,
    bool resetLastDailyHintDate = false,
    Map<String, CountryProgress>? countries,
  }) {
    return PlayerProgress(
      totalRounds: totalRounds ?? this.totalRounds,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      perfectRounds: perfectRounds ?? this.perfectRounds,
      totalHintsUsed: totalHintsUsed ?? this.totalHintsUsed,
      hintBalance: hintBalance ?? this.hintBalance,
      lastDailyHintDate: resetLastDailyHintDate
          ? null
          : (lastDailyHintDate ?? this.lastDailyHintDate),
      countries: countries ?? Map<String, CountryProgress>.from(this.countries),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRounds': totalRounds,
      'totalQuestions': totalQuestions,
      'totalCorrect': totalCorrect,
      'perfectRounds': perfectRounds,
      'totalHintsUsed': totalHintsUsed,
      'hintBalance': hintBalance,
      'lastDailyHintDate': lastDailyHintDate,
      'countries': countries.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  static PlayerProgress fromJson(Map<String, dynamic> json) {
    final rawCountries = json['countries'];
    final parsedCountries = <String, CountryProgress>{};

    if (rawCountries is Map) {
      rawCountries.forEach((key, value) {
        if (key == null || value is! Map) {
          return;
        }

        parsedCountries[key.toString()] = CountryProgress.fromJson(
          value.map(
            (mapKey, mapValue) => MapEntry(mapKey.toString(), mapValue),
          ),
        );
      });
    }

    return PlayerProgress(
      totalRounds: _parseInt(json['totalRounds']) ?? 0,
      totalQuestions: _parseInt(json['totalQuestions']) ?? 0,
      totalCorrect: _parseInt(json['totalCorrect']) ?? 0,
      perfectRounds: _parseInt(json['perfectRounds']) ?? 0,
      totalHintsUsed: _parseInt(json['totalHintsUsed']) ?? 0,
      hintBalance: _parseInt(json['hintBalance']) ?? 0,
      lastDailyHintDate: json['lastDailyHintDate']?.toString(),
      countries: parsedCountries,
    );
  }
}

class RoundRecord {
  final String country;
  final int totalQuestions;
  final int correctAnswers;
  final int timeouts;
  final bool timerWasEnabled;
  final int hintsUsed;

  const RoundRecord({
    required this.country,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeouts,
    required this.timerWasEnabled,
    required this.hintsUsed,
  });
}

class PlayerProgressController extends ChangeNotifier {
  final Future<void> Function(PlayerProgress progress)? _onProgressChanged;
  PlayerProgress _progress;

  PlayerProgressController({
    PlayerProgress initialProgress = const PlayerProgress(),
    Future<void> Function(PlayerProgress progress)? onProgressChanged,
  })  : _progress = initialProgress,
        _onProgressChanged = onProgressChanged;

  PlayerProgress get progress => _progress;

  Set<AchievementId> get unlockedAchievements {
    final result = <AchievementId>{};
    for (final country in _progress.countries.values) {
      result.addAll(country.unlockedAchievements);
    }
    return result;
  }

  List<AchievementId> recordRound(RoundRecord record) {
    final normalizedCountry = record.country.trim().toLowerCase();
    if (normalizedCountry.isEmpty || record.totalQuestions <= 0) {
      return const <AchievementId>[];
    }

    final previousUnlocked = unlockedAchievements;

    final countries = Map<String, CountryProgress>.from(_progress.countries);
    final countryProgress = countries[normalizedCountry] ?? CountryProgress();

    final nextCountryProgress = countryProgress.copyWith(
      rounds: countryProgress.rounds + 1,
      questions: countryProgress.questions + record.totalQuestions,
      correct: countryProgress.correct + record.correctAnswers,
    );

    countries[normalizedCountry] = nextCountryProgress;

    var next = _progress.copyWith(
      totalRounds: _progress.totalRounds + 1,
      totalQuestions: _progress.totalQuestions + record.totalQuestions,
      totalCorrect: _progress.totalCorrect + record.correctAnswers,
      perfectRounds: _progress.perfectRounds +
          (record.correctAnswers == record.totalQuestions ? 1 : 0),
      totalHintsUsed: _progress.totalHintsUsed + record.hintsUsed,
      countries: countries,
    );

    final evaluated = _evaluateAchievements(next, record);
    final newlyUnlocked = evaluated.difference(previousUnlocked).toList();

    if (newlyUnlocked.isNotEmpty) {
      final withAchievements = countries[normalizedCountry]!.copyWith(
        unlockedAchievements: {
          ...countries[normalizedCountry]!.unlockedAchievements,
          ...newlyUnlocked,
        },
      );
      countries[normalizedCountry] = withAchievements;
      next = next.copyWith(countries: countries);
    }

    _updateProgress(next);
    return newlyUnlocked;
  }

  DailyHintClaimResult claimDailyHintIfNeeded(DateTime nowLocal) {
    final dayKey = _formatDayKey(nowLocal);
    if (_progress.lastDailyHintDate == dayKey) {
      return DailyHintClaimResult.alreadyClaimed;
    }

    if (_progress.hintBalance >= 5) {
      _updateProgress(_progress.copyWith(lastDailyHintDate: dayKey));
      return DailyHintClaimResult.capped;
    }

    _updateProgress(
      _progress.copyWith(
        lastDailyHintDate: dayKey,
        hintBalance: _progress.hintBalance + 1,
      ),
    );
    return DailyHintClaimResult.granted;
  }

  bool tryConsumeHint() {
    if (_progress.hintBalance <= 0) {
      return false;
    }

    _updateProgress(_progress.copyWith(hintBalance: _progress.hintBalance - 1));
    return true;
  }

  Set<AchievementId> _evaluateAchievements(
      PlayerProgress value, RoundRecord round) {
    final result = <AchievementId>{...unlockedAchievements};

    if (value.totalRounds >= 1) {
      result.add(AchievementId.firstRound);
    }
    if (value.totalRounds >= 5) {
      result.add(AchievementId.fiveRounds);
    }
    if (value.totalRounds >= 20) {
      result.add(AchievementId.twentyRounds);
    }
    if (value.perfectRounds > 0) {
      result.add(AchievementId.perfectRound);
    }
    if (value.totalQuestions >= 50 &&
        (value.totalCorrect / value.totalQuestions) >= 0.8) {
      result.add(AchievementId.accuracyMaster);
    }
    if (value.countries.values.where((country) => country.rounds > 0).length >=
        5) {
      result.add(AchievementId.worldExplorer);
    }
    if (value.totalHintsUsed >= 10) {
      result.add(AchievementId.hintTactician);
    }
    if (round.timerWasEnabled &&
        round.timeouts == 0 &&
        round.totalQuestions > 0 &&
        (round.correctAnswers / round.totalQuestions) >= 0.8) {
      result.add(AchievementId.speedClean);
    }

    return result;
  }

  void _updateProgress(PlayerProgress next) {
    _progress = next;
    notifyListeners();
    unawaited(_onProgressChanged?.call(_progress));
  }

  String _formatDayKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

class PlayerProgressScope extends InheritedNotifier<PlayerProgressController> {
  const PlayerProgressScope({
    super.key,
    required PlayerProgressController controller,
    required super.child,
  }) : super(notifier: controller);

  static PlayerProgressController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<PlayerProgressScope>();
    assert(scope != null, 'PlayerProgressScope is not found in widget tree.');
    return scope!.notifier!;
  }
}

int? _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value.trim());
  }
  return null;
}

AchievementId? _achievementFromName(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  for (final value in AchievementId.values) {
    if (value.name == raw) {
      return value;
    }
  }
  return null;
}
