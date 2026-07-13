# Architecture

This project follows Clean Architecture adapted for Flutter. The dependency rule is strict: **outer layers can import inner layers, never the reverse.**

```
┌─────────────────────────────┐
│        Features / UI        │  ← BLoC/Cubit, Pages, Widgets
├─────────────────────────────┤
│            Data             │  ← Repos, Models, Local storage
├─────────────────────────────┤
│            Core             │  ← Network, Router, Base classes
└─────────────────────────────┘
```

---

## Layer Rules

### `core/`
- Contains zero business logic and zero feature knowledge.
- Safe to import from anywhere in the project.
- Sub-folders: `base/`, `constants/`, `enums/`, `network/`, `router/`, `styles/`, `utils/`.

### `data/`
- No Flutter widget imports (`package:flutter/...` is banned here).
- `repo/` holds abstract interfaces. `repo_impl/` holds concrete implementations.
- `models/` holds plain Dart classes for JSON parsing only — no business logic in models.
- `local/` holds the `Prefs` wrapper for SharedPreferences.

### `features/`
- Each feature is a self-contained folder: `bloc/`, `view/`, `widgets/`.
- A feature **may** import from `core/`, `data/`, `widgets/` (shared), and its own sub-folders.
- A feature **must not** import from another feature. Cross-feature navigation goes through the router.

### `widgets/`
- Shared UI components used by two or more features.
- No business logic. No cubit/bloc references — accept data via constructor params or callbacks.

### `dependencies/`
- The only place allowed to import both `data/` and `features/` at once.
- All `get_it` registrations live here.
- Use `registerLazySingleton` for repos and services (created on first access).
- Use `registerSingleton` only for things that must be ready before `runApp` (e.g. `Prefs`, `AppData`).

---

## Data Flow

```
UI (Page / Widget)
   │  calls cubit method
   ▼
Cubit
   │  calls use case (optional) or repo directly
   ▼
UseCase  ← add when logic is non-trivial
   │
   ▼
Repository (abstract interface in data/repo/)
   │  implemented by
   ▼
RepoImpl  →  AppServices (Dio)  →  Backend API
          →  Prefs              →  Local storage
```

**When to add a UseCase:** add one when combining multiple repo calls, transforming data, or enforcing a business rule. For simple fetch/display screens, calling the repo directly from the cubit is fine.

---

## Flavors

| Flavor | Entry point | Base URL |
|---|---|---|
| dev | `lib/main_dev.dart` | `dev-api.yourapp.com` |
| stage | `lib/main_stage.dart` | `stage-api.yourapp.com` |
| prod | `lib/main_prod.dart` | `api.yourapp.com` |

Update the URLs in `lib/core/base/base_data/base_urls.dart`.

---

## Dependency Injection

Registered in `lib/dependencies/dependencies.dart` via `get_it`.

```
startup order:
  1. Prefs (async init)
  2. AppData, Logger, Urls, AppTheme
  3. AppServices (lazy)
  4. Repos (lazy)
  5. Feature-level global cubits (lazy, if any)
```

Access injected objects anywhere via the shorthands in `lib/dependencies/get_dependencies.dart`:

```dart
appData   // AppData
logger    // Logger
urls      // Urls
prefs     // Prefs
```

---

## Base UI Layer

These classes in `lib/core/base/base_ui/` are the building blocks for every screen. Use them instead of raw Flutter widgets.

### `BasePage`

The single Scaffold wrapper for the whole app. **Never use `Scaffold` directly in feature code.**

```dart
BasePage(
  appBar: AppBar(title: const Text('Title')),
  onRefresh: () async => context.read<MyCubit>().load(),
  child: ...,
)
```

Key parameters:

| Parameter | Type | Purpose |
|---|---|---|
| `child` | `Widget?` | Main body content |
| `appBar` | `PreferredSizeWidget?` | Standard AppBar |
| `onRefresh` | `Future<void> Function()?` | Enables pull-to-refresh |
| `bottomNavigationBar` | `Widget?` | Bottom bar / sticky CTA |
| `floatingActionButton` | `Widget?` | FAB |
| `hasSafeArea` | `bool` (default `true`) | Wraps in SafeArea |
| `safeAreaBottom` | `bool` (default `false`) | Extends safe area to bottom |
| `canPop` | `bool` (default `true`) | Controls back gesture |
| `onPopInvoked` | callback | Called on back navigation |
| `backgroundColor` | `Color?` | Overrides default white |
| `decoration` | `Decoration?` | Full custom background |

### `StateWidget`

Automatically routes to the correct UI based on the cubit's state — eliminating loading/error boilerplate.

```dart
StateWidget<MyCubit>(
  retry: () => context.read<MyCubit>().load(),
  builder: (context, state) {
    // Called only when state.isSuccess
    final data = state.cast<MyState>().data;
    return Text(data.title);
  },
  // Optional overrides:
  loadingBuilder: (context, state) => const MySkeletonLoader(),
  errorBuilder: (context, state) => MyCustomError(message: state.error!.message!),
)
```

Default fallbacks when no custom builder is provided:
- Loading → `DefaultLoadingWidget` (centered spinner using `context.theme.primary`)
- Error → `DefaultErrorWidget` (error icon + message + optional retry button)
- Initial → empty `SizedBox`

### `context.theme`

Access the app's color system anywhere in the widget tree:

```dart
context.theme.primary       // brand color
context.theme.light         // white
context.theme.dark          // black
context.theme.text          // body text color
context.theme.hint          // placeholder / secondary text
context.theme.error         // red
context.theme.success       // green
context.theme.background    // page background
context.theme.transparent   // Colors.transparent
```

Override theme colors by subclassing `Themes` in `lib/core/styles/theme.dart`.

### `BlocObserver`

`MyBlocObserver` is registered in `main_dev.dart` via `Bloc.observer`. It logs every state change and event to the console in debug mode — no extra setup needed.
