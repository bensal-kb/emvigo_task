# emvigo_test

A Flutter project following Clean Architecture with BLoC/Cubit state management.

## Quick Start

```bash
flutter pub get

# Run on a specific flavor
flutter run -t lib/main_dev.dart    # development
flutter run -t lib/main_stage.dart  # staging
flutter run -t lib/main_prod.dart   # production
```

## Project Structure

```
lib/
├── core/                  # Framework-level code, never imports features
│   ├── base/              # Base classes (BaseState, UseCase)
│   ├── constants/         # App-wide constants (URLs, keys)
│   ├── enums/             # Shared enums (Flavors, Status)
│   ├── network/           # Dio client, response/exception wrappers
│   ├── router/             # go_router setup and route names
│   ├── styles/             # AppTheme, AppColors
│   └── utils/              # AppData, extensions, helpers
├── data/                  # Data layer — no Flutter/UI imports
│   ├── local/              # SharedPreferences wrapper (Prefs)
│   ├── models/             # Request/response/entity models
│   │   ├── req/            # Request bodies
│   │   ├── res/            # Response DTOs
│   │   └── entities/       # Domain entities
│   ├── repo/                # Abstract repository interfaces
│   └── repo_impl/           # Concrete implementations
├── dependencies/           # get_it DI wiring
├── features/                # One folder per screen/feature
│   └── <feature>/
│       ├── bloc/            # Cubits and states
│       ├── view/            # Page widgets (screens)
│       └── widgets/         # Widgets used only by this feature
└── widgets/                 # Shared widgets used across features
```

## Guides

| Document | Purpose |
|---|---|
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Layer rules and data flow |
| [docs/FEATURE_GUIDE.md](docs/FEATURE_GUIDE.md) | Step-by-step: adding a new feature |
| [docs/CUBIT_GUIDE.md](docs/CUBIT_GUIDE.md) | Writing cubits and states |
| [docs/REPO_GUIDE.md](docs/REPO_GUIDE.md) | Writing repos and use cases |
| [docs/STYLE_GUIDE.md](docs/STYLE_GUIDE.md) | Naming, formatting, conventions |
# emvigo_task
