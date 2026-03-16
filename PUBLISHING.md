# Publishing to pub.dev

Before publishing, do the following:

1. **Update repository URLs** in `pubspec.yaml`:
   - Replace `yourusername` in `homepage`, `repository`, and `issue_tracker` with your GitHub username or org.

2. **Validate the package**:
   ```bash
   flutter pub publish --dry-run
   ```
   Fix any errors or warnings (e.g. missing description, license, or changelog).

3. **Optional: change Android package name** (recommended for production):
   - In `pubspec.yaml` under `flutter.plugin.platforms.android.package`, change from `com.example.flutter_screenshot_guard` to e.g. `com.yourcompany.flutter_screenshot_guard`.
   - Rename the Kotlin package and folder structure under `android/src/main/kotlin/` to match.
   - Update `android/build.gradle` `namespace` and `group` to match.
   - Update `android/src/main/AndroidManifest.xml` if it references the package.
   - Update the example app’s `MainActivity` package if it imports the plugin.

4. **Publish**:
   ```bash
   flutter pub publish
   ```
   You will need a pub.dev account and to confirm with `y` when prompted.

5. **After publishing**:
   - Add the package URL to the README badge: `https://img.shields.io/pub/v/flutter_screenshot_guard.svg`
   - Tag the release in git: `git tag 1.0.0 && git push --tags`
