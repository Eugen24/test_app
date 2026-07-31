import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/utils/result.dart';
import 'package:test_app/features/map/domain/location_pin.dart';
import 'package:test_app/features/map/domain/location_repository.dart';
import 'package:test_app/features/map/presentation/providers/location_providers.dart';
import 'package:test_app/features/map/presentation/widgets/bottom_panel.dart';

class _FailingLocationRepository implements LocationRepository {
  @override
  Future<Result<List<LocationPin>, AppError>> getLocations() async {
    return const Result.failure(AppError.unknown);
  }
}

class _NeverResolvingLocationRepository implements LocationRepository {
  @override
  Future<Result<List<LocationPin>, AppError>> getLocations() {
    return Completer<Result<List<LocationPin>, AppError>>().future;
  }
}

class _EmptyLocationRepository implements LocationRepository {
  @override
  Future<Result<List<LocationPin>, AppError>> getLocations() async {
    return const Result.success(<LocationPin>[]);
  }
}

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

    expect(find.text('Nobil Tower Office Parking'), findsOneWidget);
    expect(find.text('Hotel Codru Guest Parking'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'codru');
    await tester.pumpAndSettle();

    expect(find.text('Hotel Codru Guest Parking'), findsOneWidget);
    expect(find.text('Nobil Tower Office Parking'), findsNothing);
  });

  testWidgets('BottomPanel shows a loading indicator while resolving', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationRepositoryProvider.overrideWithValue(
            _NeverResolvingLocationRepository(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: BottomPanel())),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('No matching locations found.'), findsNothing);
  });

  testWidgets('BottomPanel shows the AppError message on failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationRepositoryProvider.overrideWithValue(
            _FailingLocationRepository(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: BottomPanel())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppError.unknown.message), findsOneWidget);
    expect(find.text('No matching locations found.'), findsNothing);
  });

  testWidgets(
    'BottomPanel shows the empty message when the search yields no results',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            locationRepositoryProvider.overrideWithValue(
              _EmptyLocationRepository(),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BottomPanel())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No matching locations found.'), findsOneWidget);
    },
  );
}
