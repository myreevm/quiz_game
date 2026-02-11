import 'package:flutter/material.dart';
import 'region_selection_screen.dart';

class CountrySelectionScreen extends StatelessWidget {
  const CountrySelectionScreen({super.key});

  final countries = const {
    'russia': 'Россия',
    'usa': 'США',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор страны')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: countries.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegionSelectionScreen(
                        country: entry.key,
                      ),
                    ),
                  );
                },
                child: Text(entry.value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
