import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'golden path: splash -> onboarding -> map -> select marker -> profile -> back',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      expect(find.text('Parqie'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('Nearby Parking'), findsOneWidget);
      expect(find.text('Nobil Tower Office Parking'), findsOneWidget);

      await tester.tap(find.text('Nobil Tower Office Parking').first);
      await tester.pumpAndSettle();
      expect(find.text('Reserve Spot'), findsOneWidget);

      // Dismiss the detail sheet by tapping the scrim, then confirm the
      // card behind it is now marked selected.
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.person_rounded));
      await tester.pumpAndSettle();
      expect(find.textContaining('Alex'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Nearby Parking'), findsOneWidget);
    },
  );
}
