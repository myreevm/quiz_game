import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  static Future<List<Question>> loadQuestions({
    required String country,
    String? region, // теперь необязательный
    required String category,
  }) async {
    final path = region == null
        ? 'assets/data/$country/$category.json' // страна целиком
        : 'assets/data/$country/$region/$category.json'; // конкретный регион

    try {
      final String jsonString = await rootBundle.loadString(path);
      final List data = json.decode(jsonString);

      return data.map<Question>((q) {
        return Question(
          questionText: q['question'],
          answers: (q['answers'] as List)
              .map((a) => Answer(text: a['text'], score: a['score']))
              .toList(),
        );
      }).toList();
    } catch (e) {
      print('Ошибка загрузки $path: $e');
      return [];
    }
  }
}
