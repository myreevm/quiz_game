import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SwitchListTile(
        title: const Text('Звук'),
        value: soundEnabled,
        onChanged: (value) {
          setState(() {
            soundEnabled = value;
          });
        },
      ),
    );
  }
}
