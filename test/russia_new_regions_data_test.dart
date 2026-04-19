import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/app_settings.dart';
import 'package:quiz_app/services/question_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const regions = <String>[
    'adygea',
    'bashkortostan',
    'altai',
    'buryatia',
    'kalmykia',
    'kabardino_balkaria',
    'ingushetia',
    'kamchatka',
    'mari_el',
    'komi',
    'karelia',
    'karachay_cherkessia',
    'tuva',
    'tatarstan',
    'north_ossetia',
    'mordovia',
    'chuvashia',
    'chechnya',
    'khakassia',
    'udmurtia',
    'krasnoyarsk_krai',
    'krasnodar_krai',
    'zabaykalsky_krai',
    'altai_krai',
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

  test(
      'new Russia regions have question packs for all categories and languages',
      () async {
    for (final region in regions) {
      for (final category in categories) {
        for (final language in languages) {
          final questions = await QuestionService.loadQuestions(
            country: 'russia',
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
