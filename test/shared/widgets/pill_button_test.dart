import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/shared/widgets/pill_button.dart';

void main() {
  testWidgets('PillButton renders label and calls onPressed', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: PillButton(
          label: 'Use Current Location',
          onPressed: () => pressed = true,
        ),
      ),
    );

    expect(find.text('Use Current Location'), findsOneWidget);
    await tester.tap(find.byType(PillButton));
    expect(pressed, isTrue);
  });
}
