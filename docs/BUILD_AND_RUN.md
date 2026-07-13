# Build & Run

## Prerequisites

- Flutter SDK (Dart `^3.12.2`, matching `pubspec.yaml`). Verify with `flutter --version`.
- Android Studio (with an Android SDK + at least one emulator or a physical device) and/or Xcode
  (for iOS, macOS only).
- A device or emulator/simulator connected. Check with `flutter devices`.

## 1. Install dependencies

```bash
flutter pub get
```

## 2. Firebase

This app uses **Firebase Authentication** (email/password) and **Cloud Firestore**. The project is
already configured to talk to its Firebase project — the following files are checked into the repo
and require no setup for a normal clone:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`
- `firebase.json`

You only need to touch Firebase setup if you're pointing the app at a **different** Firebase
project. In that case, run:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This regenerates the files above. Do not commit new config files over the existing ones unless
you've intentionally switched projects.

## 3. Run the app

The app has three flavors, each with its own entry point and API base URL
(`lib/core/base/base_data/base_urls.dart`):

```bash
flutter run -t lib/main_dev.dart    # development (default)
flutter run -t lib/main_stage.dart  # staging
flutter run -t lib/main_prod.dart   # production
```

Running `flutter run` with no `-t` flag uses `lib/main.dart`, which is a thin wrapper that always
launches the **dev** flavor — equivalent to `-t lib/main_dev.dart`.

To target a specific device, add `-d <device-id>` (see `flutter devices` for ids).

## 4. Build

```bash
# Android debug APK
flutter build apk --debug -t lib/main_dev.dart

# Android release APK (signed with the debug keystore by default — see
# android/app/build.gradle.kts's TODO before shipping)
flutter build apk --release -t lib/main_prod.dart

# iOS (macOS only, requires a valid signing setup in Xcode)
flutter build ios -t lib/main_prod.dart
```

## 5. Verify

```bash
flutter analyze          # static analysis
flutter test              # unit/widget tests
flutter test test/widget_test.dart          # a single test file
flutter test --plain-name "<test name>"     # a single test by name
```

## Troubleshooting

- **`flutter_local_notifications requires core library desugaring`** — already handled in
  `android/app/build.gradle.kts` (`isCoreLibraryDesugaringEnabled = true` + the
  `coreLibraryDesugaring` dependency). If you see this error, that config was likely reverted.
- **`Your app uses the following plugins that apply Kotlin Gradle Plugin (KGP)` warning** — a
  known upstream `package_info_plus` deprecation notice, not a build failure. Safe to ignore.
- **Stuck on the Sign In screen after a fresh install** — expected: the router redirects
  unauthenticated users to Sign In/Signup (`lib/core/router/app_router.dart`). Create an account via
  Signup to proceed.
