import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/shared/widgets/shadow_card.dart';

void main() {
  testWidgets('ShadowCard renders its child and responds to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ShadowCard(
          onTap: () => tapped = true,
          child: const Text('Card content'),
        ),
      ),
    );

    expect(find.text('Card content'), findsOneWidget);
    await tester.tap(find.byType(ShadowCard));
    expect(tapped, isTrue);
  });
}
