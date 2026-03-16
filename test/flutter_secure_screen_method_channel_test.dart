import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_screen/flutter_secure_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('flutter_secure_screen');

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
    await FlutterSecureScreen.enableScreenshotBlocking();
    await FlutterSecureScreen.disableScreenshotBlocking();
    await FlutterSecureScreen.enableBlurOnBackground();
    await FlutterSecureScreen.disableBlurOnBackground();
    await FlutterSecureScreen.enableSecureMode();
    await FlutterSecureScreen.disableSecureMode();
    await FlutterSecureScreen.setBlurIntensity(0.5);
  });
}
