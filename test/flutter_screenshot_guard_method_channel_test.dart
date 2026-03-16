import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenshot_guard/flutter_screenshot_guard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('flutter_screenshot_guard');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('all methods complete without error when channel succeeds', () async {
    await FlutterScreenshotGuard.enableScreenshotBlocking();
    await FlutterScreenshotGuard.disableScreenshotBlocking();
    await FlutterScreenshotGuard.enableBlurOnBackground();
    await FlutterScreenshotGuard.disableBlurOnBackground();
    await FlutterScreenshotGuard.enableSecureMode();
    await FlutterScreenshotGuard.disableSecureMode();
    await FlutterScreenshotGuard.setBlurIntensity(0.5);
  });
}
