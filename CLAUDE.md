# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

Flutter app structured on Clean Architecture with BLoC/Cubit state management, set up to mirror the
conventions of the `flutter_template` project. The base scaffolding (core layer, DI, router, theming,
network layer, one example `auth` feature) is in place; most feature folders under `lib/data/` and
`lib/widgets/` are intentionally empty (kept via `.gitkeep`) as placeholders for future work.

Full guides live in `docs/` — read these before adding code, they are the source of truth for
conventions, not this file:

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — layer rules and data flow
- [docs/FEATURE_GUIDE.md](docs/FEATURE_GUIDE.md) — step-by-step: adding a new feature
- [docs/CUBIT_GUIDE.md](docs/CUBIT_GUIDE.md) — writing cubits and states
- [docs/REPO_GUIDE.md](docs/REPO_GUIDE.md) — writing repos and use cases
- [docs/STYLE_GUIDE.md](docs/STYLE_GUIDE.md) — naming, formatting, conventions

## Commands

- Install dependencies: `flutter pub get`
- Run a flavor: `flutter run -t lib/main_dev.dart` (or `main_stage.dart` / `main_prod.dart`)
- Static analysis: `flutter analyze`
- Run all tests: `flutter test`
- Run a single test file: `flutter test test/widget_test.dart`
- Run a single test by name: `flutter test --plain-name "<test name>"`
- Format code: `dart format .`

## Architecture

Strict layering, outer layers may import inner layers but never the reverse:

```
features/ (BLoC/Cubit, Pages, Widgets)
   → data/ (Repos, Models, local storage)
      → core/ (Network, Router, base classes — zero feature/business knowledge)
```

- `lib/core/` — framework-level code: `base/` (BaseState, BasePage, StateWidget, UseCase),
  `network/` (Dio wrapper `AppServices`, `Response<T>`, `Error` hierarchy), `router/` (go_router,
  `Routes`), `styles/` (`AppTheme`, `Themes` — access via `context.theme`, never hardcode colors),
  `enums/` (`Flavors`), `utils/` (`AppData`).
- `lib/data/` — no Flutter imports allowed. `repo/` = abstract interfaces, `repo_impl/` = concrete
  implementations backed by `AppServices`, `models/{req,res,entities}/`, `local/prefs.dart` wraps
  SharedPreferences.
- `lib/dependencies/` — the only place that wires both `data/` and `features/`. All `get_it`
  registrations live in `dependencies.dart`; access injected singletons anywhere via the shorthands
  in `get_dependencies.dart` (`sl`, `appData`, `logger`, `urls`, `prefs`).
- `lib/features/<feature>/` — `bloc/`, `view/`, `widgets/` per feature. A feature must never import
  another feature; cross-feature navigation goes through the router (`go_router`).
- `lib/widgets/` — shared widgets used by 2+ features, no business logic, no bloc/cubit references.

Three build flavors (`lib/main_dev.dart`, `main_stage.dart`, `main_prod.dart`) all funnel through
`runFlavor()` in `main_dev.dart`; base URLs per flavor are set in `lib/core/base/base_data/base_urls.dart`.
Firebase packages are dependencies but intentionally uncommented/inactive until `flutterfire configure`
is run (see the comment block in `main_dev.dart`).

Never use `Scaffold` directly in feature code — use `BasePage`. Never repeat loading/error
boilerplate in a `BlocBuilder` — use `StateWidget<YourCubit>` which handles it via `BaseState`.

## Assets

`assets/{icons,images,svg,lottie}/` are registered in `pubspec.yaml`; reference them through an
`Assets` constants class (see `docs/STYLE_GUIDE.md`) rather than raw string paths.

## Bricks

`bricks/cubit_brick/` and `bricks/feature_brick/` are placeholders for Mason code-gen templates
(the `mason` dev dependency is present) — not yet implemented.
