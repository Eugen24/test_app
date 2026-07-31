# Parqie

A Flutter app simulating a simple location-based service: splash screen, interactive
map with mocked location pins, and a bottom panel for search / current-location /
location details, plus a mocked profile screen.

## Getting Started

```bash
flutter pub get
flutter run
```

No API keys required — the map uses OpenStreetMap tiles via `flutter_map`.

## Architecture

Feature-first Clean Architecture (`domain` / `data` / `presentation` per feature),
state managed with Riverpod. See `docs/superpowers/specs/2026-07-31-parqie-flutter-assignment-design.md`
for the full design spec and `docs/superpowers/plans/2026-07-31-parqie-app.md` for the
implementation plan this was built from.

## Key trade-offs

- **flutter_map + OpenStreetMap instead of Google Maps** — avoids requiring reviewers
  to configure API keys/billing to run the app. Marker/camera APIs are comparable.
- **All data is mocked** per the assignment brief — `MockLocationRepository` and
  `MockProfileRepository` return hardcoded data behind the same `Result`-returning
  interfaces a real backend-backed implementation would use.

## Testing

```bash
flutter test                              # unit + widget tests
flutter test integration_test/app_test.dart -d <device-id>   # golden-path E2E (needs a device/emulator/simulator)
```

## CI

GitHub Actions (`.github/workflows/ci.yml`) runs formatting, analysis, and tests on
every push/PR to `main`.
