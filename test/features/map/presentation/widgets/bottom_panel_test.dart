import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/features/map/presentation/widgets/bottom_panel.dart';

void main() {
  testWidgets('BottomPanel filters location cards as the user types', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: BottomPanel())),
      ),
    );
    // The mock repository resolves after a real 150ms delay; pumpAndSettle's
    // default 100ms step stops before that fires because nothing else keeps
    // scheduling frames in the interim, so advance the clock explicitly first.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(find.text('Riverside Park'), findsOneWidget);
    expect(find.text('Downtown Coffee Co.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'coffee');
    await tester.pumpAndSettle();

    expect(find.text('Downtown Coffee Co.'), findsOneWidget);
    expect(find.text('Riverside Park'), findsNothing);
  });
}
