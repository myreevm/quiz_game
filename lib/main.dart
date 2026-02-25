import 'package:flutter/material.dart';

import 'models/app_settings.dart';
import 'models/app_texts.dart';
import 'models/player_progress.dart';
import 'services/app_settings_storage.dart';
import 'services/player_progress_storage.dart';
import 'screens/main_menu_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsStorage = AppSettingsStorage();
  final initialSettings = await settingsStorage.load();
  final settingsController = AppSettingsController(
    initialSettings: initialSettings,
    onSettingsChanged: settingsStorage.save,
  );

  final progressStorage = PlayerProgressStorage();
  final initialProgress = await progressStorage.load();
  final progressController = PlayerProgressController(
    initialProgress: initialProgress,
    onProgressChanged: progressStorage.save,
  );

  runApp(
    QuizApp(
      settingsController: settingsController,
      progressController: progressController,
    ),
  );
}

class QuizApp extends StatelessWidget {
  final AppSettingsController settingsController;
  final PlayerProgressController progressController;

  const QuizApp({
    super.key,
    required this.settingsController,
    required this.progressController,
  });

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      controller: settingsController,
      child: PlayerProgressScope(
        controller: progressController,
        child: AnimatedBuilder(
          animation: settingsController,
          builder: (context, _) {
            final isDarkMode = settingsController.settings.darkModeEnabled;
            final texts = AppTexts.of(context);

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: texts.appTitle,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.indigo,
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.indigo,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              home: const MainMenuScreen(),
            );
          },
        ),
      ),
    );
  }
}
