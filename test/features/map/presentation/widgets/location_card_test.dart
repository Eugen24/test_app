import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/features/map/domain/location_pin.dart';
import 'package:test_app/features/map/presentation/widgets/location_card.dart';

void main() {
  testWidgets('LocationCard shows name, description, and reports taps', (tester) async {
    const pin = LocationPin(
      id: 'loc-1',
      name: 'Riverside Park',
      description: 'Open green space along the river.',
      category: 'park',
      lat: 0,
      lng: 0,
    );
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationCard(pin: pin, selected: false, onTap: () => tapped = true),
        ),
      ),
    );

    expect(find.text('Riverside Park'), findsOneWidget);
    expect(find.text('Open green space along the river.'), findsOneWidget);

    await tester.tap(find.byType(LocationCard));
    expect(tapped, isTrue);
  });
}
