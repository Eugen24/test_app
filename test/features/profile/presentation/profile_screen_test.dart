import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/features/profile/presentation/profile_screen.dart';

void main() {
  testWidgets('ProfileScreen renders greeting and stat cards from mock data', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ProfileScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Alex'), findsOneWidget);
    expect(find.textContaining('spots'), findsWidgets);
  });
}
