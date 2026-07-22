# Architecture

This project follows a feature-first Clean Architecture style for a Flutter app.

## Layer model

The app is organized into three main layers:

- Presentation: screens, widgets, and Cubits that render UI and react to state.
- Domain: use cases, entities, and business rules.
- Data: repositories, data sources, models, and external integrations.

The important rule is simple: UI should not contain business logic, and domain code should not depend on Flutter.

## Feature structure

Features live under `lib/features/<feature_name>/` and usually contain:

- `data/`
- `domain/`
- `presentation/`

Keep code inside the feature that owns it. Move shared helpers, constants, and reusable UI into `lib/core/` when they are needed in more than one place.

## State management

Use `flutter_bloc` and Cubit for feature state.

- Cubits should depend on use cases, not on data sources directly.
- Keep local widget state in the widget tree when it is only needed for UI concerns.
- Avoid adding a second state-management approach unless the repo already uses it for that area.

## Dependency injection

Use `get_it` as the service locator.

- Register long-lived services with `registerLazySingleton`.
- Register transient objects like Cubits with `registerFactory`.
- Keep registrations centralized in `lib/core/di/dependency_injection.dart` or the current DI entrypoint used by the repo.

## Routing

Routing is centralized rather than scattered through the app.

- Route names live in `lib/core/routing/routes.dart`.
- Route setup lives in `lib/core/routing/app_router.dart`.
- New screens should be wired through the central router instead of navigating around it.

## UI and RTL

This is an Arabic-first app, so UI must remain RTL-safe.

- Prefer `EdgeInsetsDirectional`, `AlignmentDirectional`, and other directional APIs.
- Do not hardcode left/right layout assumptions when a directional option exists.
- Keep text, icons, and spacing readable in Arabic layouts.
- Use the app's existing theme and typography system instead of introducing a new visual language.

## Data and networking

The repo expects standard Flutter data-layer patterns.

- Use repositories to hide data-source details.
- Keep API parsing and local storage code out of UI widgets.
- Map external data into app models at the data boundary.
- Handle errors as close to the data boundary as practical, then surface user-friendly states upward.

## Adding a feature

A typical feature change should follow this order:

1. Define the data contracts and source if needed.
2. Add or update the repository implementation.
3. Add the use case or domain logic.
4. Add the Cubit and its states.
5. Build the presentation layer.
6. Register dependencies.
7. Wire the route.
8. Validate the affected slice.

## Cross-checks

Before making broad changes, check whether the repo already has a dedicated convention or doc for the area you are touching. Existing guidance in `CLAUDE.md` and `.github/copilot-instructions.md` is authoritative for behavior details.
