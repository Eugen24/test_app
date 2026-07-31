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

## Known trade-offs

- **Poppins is fetched over the network via `google_fonts`, not bundled** — on
  first run the package downloads and caches the Poppins font files from
  Google Fonts. `google_fonts` gracefully falls back to the platform default
  font if the device is offline, so this never breaks the UI, just its exact
  typography on a first offline run. Bundling the `.ttf` files as local assets
  would remove this network dependency entirely; that wasn't done here to
  avoid adding binary font assets to the repo in this sandboxed environment.

## Testing

```bash
flutter test                              # unit + widget tests
flutter test integration_test/app_test.dart -d <device-id>   # golden-path E2E (needs a device/emulator/simulator)
```

## CI

GitHub Actions (`.github/workflows/ci.yml`) runs formatting, analysis, and tests on
every push/PR to `main`.
