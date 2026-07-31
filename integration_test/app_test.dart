import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'golden path: splash -> map -> select marker -> profile -> back',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      expect(find.text('Parqie'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle();

      expect(find.text('Nearby'), findsOneWidget);
      expect(find.text('Riverside Park'), findsOneWidget);

      await tester.tap(find.text('Riverside Park'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.person_rounded));
      await tester.pumpAndSettle();
      expect(find.textContaining('Alex'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Nearby'), findsOneWidget);
    },
  );
}
