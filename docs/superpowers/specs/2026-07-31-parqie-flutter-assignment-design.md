# Parqie — Flutter Location Service App: Design Spec

Date: 2026-07-31
Source: Flutter Technical Assignment (technical assessment brief, 4-day submission window)

## Objective

Build a Flutter app simulating a simple location-based service: splash screen → interactive map with mocked location pins → bottom panel for location selection/current-location + profile access. Target: full bonus scope (current location, animations, custom markers, search, integration tests, CI/CD, error handling, high-quality UI/UX).

## Visual Design Reference

Apple Podcasts "Insights" screen style: bold oversized headline typography, floating soft-shadow cards with slight rotation/tilt, pill-shaped buttons, circular avatar bubbles, generous whitespace on a light neutral background, one accent color, editorial large-number stat callouts.

Applied to:
- **Splash**: big bold wordmark/logo centered on light bg, minimal, auto-navigates after 2–3s.
- **Map screen**: standard full-bleed interactive map (flutter_map + OSM), custom pin icons, tap-to-select animates marker scale.
- **Bottom panel**: `DraggableScrollableSheet` containing location entries as tilted floating shadow-card tiles (not flat list rows), pill buttons for "Use Current Location" / "Show All Locations", search field.
- **Profile screen**: big greeting headline, floating avatar bubble (slight tilt/shadow), stat cards (e.g. "You've visited **N** locations", "Favorite spot: **X**") styled as floating shadow tiles.
- **Theme**: light neutral gray background, dark text, single accent color, 16–24px rounded corners, consistent soft drop shadows, rounded sans-serif font (Google Fonts, e.g. Poppins).

## Architecture

Feature-first Clean Architecture, Riverpod for state management.

```
lib/
  core/
    theme/                 # colors, text styles, shadows, ThemeData
    constants/
    utils/                 # Result<T,E> for error handling
    router/                # go_router: splash → map ; map → profile
  features/
    splash/
      presentation/        # SplashScreen, controller
    map/
      domain/               # Location entity, LocationRepository interface
      data/                 # MockLocationRepository (hardcoded seed data)
      presentation/
        map_screen.dart
        providers/          # locations provider, selected location provider, search query provider, current-location provider
        widgets/            # BottomPanel, LocationCard, SearchBar, MarkerIcon, CurrentLocationButton
    profile/
      domain/                # Profile entity
      data/                  # MockProfileRepository
      presentation/           # ProfileScreen, StatCard widget
  shared/
    widgets/                 # PillButton, ShadowCard (reused across features)
test/                        # unit tests (repos, providers) + widget tests
integration_test/            # golden-path flow: splash -> map -> select marker -> profile
.github/workflows/ci.yml     # flutter analyze, flutter test, flutter build apk
```

## Key Technical Decisions

- **Map**: `flutter_map` + OpenStreetMap tiles — no API key required, works cross-platform without billing setup.
- **State management**: Riverpod (`flutter_riverpod`) — providers per concern (locations list, selected location, search query, current-location async state).
- **Location detection** (bonus): `geolocator` package. Permission-denied or service-disabled states surface as a dismissible error banner in the bottom panel, not a crash.
- **Search** (bonus): local substring filter over the mocked location list, live as user types.
- **Custom markers** (bonus): custom pin asset (SVG/PNG), selected marker animates scale via `AnimatedScale`/implicit animation.
- **Animations** (bonus): implicit animations for marker selection and bottom-sheet transitions; page transition splash → map.
- **Error handling** (bonus): typed `Result<T,E>` wrapper in repositories; UI renders inline error/retry states instead of throwing.
- **Routing**: `go_router`.
- **Testing** (bonus): unit tests for repositories and providers, widget tests for BottomPanel/MarkerIcon/ProfileScreen, one `integration_test` covering the golden path.
- **CI/CD** (bonus): GitHub Actions workflow running `flutter analyze`, `flutter test`, `flutter build apk --debug` on push/PR.

## Data Model (mocked, no backend)

```dart
class LocationPin {
  final String id;
  final String name;
  final String description;
  final double lat;
  final double lng;
  final String category; // e.g. "restaurant", "park"
}

class UserProfile {
  final String name;
  final String avatarUrl; // placeholder asset
  final int visitedCount;
  final String favoriteSpot;
}
```

## Error Handling Strategy

- Repository methods return `Result<T, AppError>` (sealed success/failure) rather than throwing.
- Location permission/service errors, empty search results, and map load failures each get a distinct, user-visible state (banner or empty-state widget) — no silent failures, no raw exception text shown to the user.

## Testing Strategy

- Unit: `MockLocationRepository`, Riverpod providers (search filtering logic, selected-location state transitions).
- Widget: `LocationCard`, `BottomPanel` (search + selection), `ProfileScreen` (stat rendering).
- Integration: launch app → splash auto-navigates → map renders markers → tap marker → bottom panel updates → open profile → back.

## Git & CI

- Repo initialized locally (`main` branch). Meaningful incremental commits per feature area (scaffold, theme, splash, map+markers, bottom panel, search, current location, profile, tests, CI, docs).
- GitHub Actions CI on every push/PR: analyze, test, debug build.
- Public repo push target: GitHub (user to confirm remote before final push).

## Out of Scope

- Real backend/API integration (all data mocked per assignment).
- Google Maps (avoided to skip API key/billing setup) — flutter_map/OSM chosen instead, noted as an explicit trade-off if reviewer expects Google Maps.
