import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/screens/flag_badge.dart';

void main() {
  const svgCodes = [
    'brazil',
    'egypt',
    'south_africa',
    'italy',
    'turkey',
    'japan',
    'canada',
    'mexico',
    'moldova',
    'estonia',
    'latvia',
    'lithuania',
    'belgium',
    'netherlands',
    'ireland',
    'denmark',
    'malta',
    'monaco',
    'liechtenstein',
    'luxembourg',
    'uae',
    'bahrain',
    'qatar',
    'saudi_arabia',
    'dr_congo',
    'congo_republic',
    'zambia',
    'namibia',
    'cambodia',
    'madagascar',
    'turkmenistan',
    'oman',
    'mali',
    'mauritania',
    'kuwait',
    'angola',
    'nigeria',
    'nepal',
    'uruguay',
    'north_macedonia',
    'samoa',
    'mozambique',
    'nauru',
    'niger',
    'chad',
    'tuvalu',
    'micronesia',
    'mauritius',
    'east_timor',
    'suriname',
    'guyana',
    'venezuela',
    'saint_vincent_and_the_grenadines',
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
    'alaska',
    'alabama',
    'iowa',
    'idaho',
    'washington',
    'wyoming',
    'arkansas',
    'arizona',
    'massachusetts',
    'louisiana',
    'connecticut',
    'colorado',
    'kentucky',
    'kansas',
    'california',
    'indiana',
    'hawaii',
    'wisconsin',
    'virginia',
    'vermont',
    'illinois',
    'west_virginia',
    'delaware',
    'georgia_us',
  ];

  for (final code in svgCodes) {
    testWidgets('FlagBadge uses SvgPicture for $code', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: FlagBadge(code: code),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FlagBadge), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
