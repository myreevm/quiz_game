import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/services/question_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const regions = <String>[
    'alaska',
    'alabama',
    'iowa',
    'idaho',
  ];

  const categories = <String>[
    'famous_people',
    'history',
    'movies',
    'music',
  ];

  const languages = <AppLanguage>[
    AppLanguage.english,
    AppLanguage.russian,
    AppLanguage.yakut,
  ];

  test('new USA states have question packs for all categories and languages',
      () async {
    for (final region in regions) {
      for (final category in categories) {
        for (final language in languages) {
          final questions = await QuestionService.loadQuestions(
            country: 'usa',
            region: region,
            category: category,
            language: language,
          );

          expect(
            questions,
            isNotEmpty,
            reason:
                'Expected questions for region=$region category=$category language=$language',
          );
        }
      }
    }
  });
}
