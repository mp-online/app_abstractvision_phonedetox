# Codex Handoff — Execute PR-001

## Goal

Integrate and validate the authored Phone Detox launcher foundation in a fresh Flutter Android repository.

## Execution order

1. Read `AGENTS.md` and all documents linked from it.
2. If generated Flutter project files are absent, run:

   ```bash
   flutter create \
     --org com.abstractvision \
     --project-name phone_detox \
     --platforms android \
     .
   ```

3. Preserve the authored files in this package when `flutter create` generates files with the same names.
4. Update `android/app/build.gradle` or `build.gradle.kts` after project generation:

   ```kotlin
   android {
       namespace = "com.abstractvision.phonedetox"

       defaultConfig {
           applicationId = "com.abstractvision.phonedetox"
           minSdk = 24
       }
   }
   ```

5. Confirm Android `minSdk` is at least 24.
6. Confirm `MainActivity.kt` is located at:

   ```text
   android/app/src/main/kotlin/com/abstractvision/phone_detox/MainActivity.kt
   ```

7. Run dependency and localization generation:

   ```bash
   flutter pub get
   flutter gen-l10n
   ```

8. Resolve compile/analyzer problems without expanding scope or adding dependencies.
9. Run:

   ```bash
   dart format --set-exit-if-changed lib test
   flutter analyze --no-pub
   flutter test --no-pub
   flutter build apk --debug
   ```

10. Install on a physical Android device or emulator and execute the manual acceptance checks in `PR_DESCRIPTION.md`.
11. Update the checkboxes in `PR_DESCRIPTION.md` only after actual verification.

## Restrictions

Do not add:

- `QUERY_ALL_PACKAGES`
- Accessibility Service
- notification listener
- usage access
- analytics or crash SDKs
- network clients
- login/backend
- billing
- Drift
- router package
- installed-app plugins

Do not replace the first-party Kotlin bridge with a package merely to shorten the implementation.

## Expected final report

Return:

1. files changed
2. commands executed and results
3. Android devices/API levels tested
4. acceptance criteria that passed
5. any remaining defect with reproduction steps
6. confirmation that no restricted/sensitive capability was introduced
