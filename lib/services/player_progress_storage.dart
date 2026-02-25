import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/player_progress.dart';

class PlayerProgressStorage {
  static const String _progressKey = 'player_progress.v1';

  Future<PlayerProgress> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_progressKey);
      if (raw == null || raw.trim().isEmpty) {
        return PlayerProgress();
      }

      final decoded = json.decode(raw);
      if (decoded is! Map) {
        return PlayerProgress();
      }

      return PlayerProgress.fromJson(
        decoded.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to load player progress: $error');
      debugPrintStack(stackTrace: stackTrace);
      return PlayerProgress();
    }
  }

  Future<void> save(PlayerProgress progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(progress.toJson());
      await prefs.setString(_progressKey, encoded);
    } catch (error, stackTrace) {
      debugPrint('Failed to save player progress: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
