# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

This is a Flutter application generated from the default `flutter create` template and has not yet
been built out — `lib/main.dart` is still the stock counter demo. There is no custom architecture,
state management, routing, or backend integration in place yet. When adding features, you are
establishing the project's structure, not following an existing convention.

## Commands

- Install dependencies: `flutter pub get`
- Run the app (device/simulator must be available): `flutter run`
- Static analysis (uses `flutter_lints` via `analysis_options.yaml`): `flutter analyze`
- Run all tests: `flutter test`
- Run a single test file: `flutter test test/widget_test.dart`
- Run a single test by name: `flutter test --plain-name "Counter increments smoke test"`
- Format code: `dart format .`

## Structure

- `lib/main.dart` — app entry point (`main()` + root `MyApp` widget). All app code currently lives here.
- `test/` — widget tests using `flutter_test`.
- `android/`, `ios/` — platform runner projects; generally only touched for platform-specific config
  (permissions, signing, native plugin setup), not application logic.
- Package name is `emvigo_test`; Dart SDK constraint is `^3.12.2` (`pubspec.yaml`).
