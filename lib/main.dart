import 'package:flutter/material.dart';
import 'models/app_settings.dart';
import 'screens/main_menu_screen.dart';

void main() {
  runApp(QuizApp(controller: AppSettingsController()));
}

class QuizApp extends StatelessWidget {
  final AppSettingsController controller;

  const QuizApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      controller: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final isDarkMode = controller.settings.darkModeEnabled;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quiz Game',
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
    );
  }
}
