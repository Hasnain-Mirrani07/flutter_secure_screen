// Integration tests run against a full Flutter app and the native plugin.
// Run on a real device or simulator: flutter test integration_test/

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_secure_screen/flutter_secure_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('enableSecureMode and disableSecureMode complete', (tester) async {
    await FlutterSecureScreen.enableSecureMode();
    await FlutterSecureScreen.disableSecureMode();
  });

  testWidgets('enableScreenshotBlocking completes', (tester) async {
    await FlutterSecureScreen.enableScreenshotBlocking();
    await FlutterSecureScreen.disableScreenshotBlocking();
  });

  testWidgets('enableBlurOnBackground and setBlurIntensity complete', (tester) async {
    await FlutterSecureScreen.enableBlurOnBackground();
    await FlutterSecureScreen.setBlurIntensity(0.6);
    await FlutterSecureScreen.disableBlurOnBackground();
  });
}
