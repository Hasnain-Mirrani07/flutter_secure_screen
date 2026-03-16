// Integration tests run against a full Flutter app and the native plugin.
// Run on a real device or simulator: flutter test integration_test/

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_screenshot_guard/flutter_screenshot_guard.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('enableSecureMode and disableSecureMode complete', (tester) async {
    await FlutterScreenshotGuard.enableSecureMode();
    await FlutterScreenshotGuard.disableSecureMode();
  });

  testWidgets('enableScreenshotBlocking completes', (tester) async {
    await FlutterScreenshotGuard.enableScreenshotBlocking();
    await FlutterScreenshotGuard.disableScreenshotBlocking();
  });

  testWidgets('enableBlurOnBackground and setBlurIntensity complete', (tester) async {
    await FlutterScreenshotGuard.enableBlurOnBackground();
    await FlutterScreenshotGuard.setBlurIntensity(0.6);
    await FlutterScreenshotGuard.disableBlurOnBackground();
  });
}
