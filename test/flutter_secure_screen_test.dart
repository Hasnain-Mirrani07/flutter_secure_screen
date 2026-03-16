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

  group('FlutterSecureScreen', () {
    test('enableScreenshotBlocking invokes platform method', () async {
      String? methodCalled;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        methodCalled = call.method;
        return null;
      });

      await FlutterSecureScreen.enableScreenshotBlocking();
      expect(methodCalled, 'enableScreenshotBlocking');
    });

    test('disableScreenshotBlocking invokes platform method', () async {
      String? methodCalled;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        methodCalled = call.method;
        return null;
      });

      await FlutterSecureScreen.disableScreenshotBlocking();
      expect(methodCalled, 'disableScreenshotBlocking');
    });

    test('enableBlurOnBackground invokes platform method', () async {
      String? methodCalled;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        methodCalled = call.method;
        return null;
      });

      await FlutterSecureScreen.enableBlurOnBackground();
      expect(methodCalled, 'enableBlurOnBackground');
    });

    test('disableBlurOnBackground invokes platform method', () async {
      String? methodCalled;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        methodCalled = call.method;
        return null;
      });

      await FlutterSecureScreen.disableBlurOnBackground();
      expect(methodCalled, 'disableBlurOnBackground');
    });

    test('enableSecureMode invokes platform method', () async {
      String? methodCalled;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        methodCalled = call.method;
        return null;
      });

      await FlutterSecureScreen.enableSecureMode();
      expect(methodCalled, 'enableSecureMode');
    });

    test('disableSecureMode invokes platform method', () async {
      String? methodCalled;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        methodCalled = call.method;
        return null;
      });

      await FlutterSecureScreen.disableSecureMode();
      expect(methodCalled, 'disableSecureMode');
    });

    test('setBlurIntensity sends intensity argument', () async {
      String? methodCalled;
      dynamic args;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        methodCalled = call.method;
        args = call.arguments;
        return null;
      });

      await FlutterSecureScreen.setBlurIntensity(0.8);
      expect(methodCalled, 'setBlurIntensity');
      expect(args, isA<Map>());
      expect((args as Map)['intensity'], 0.8);
    });

    test('setBlurIntensity clamps to 0.0-1.0', () async {
      dynamic args;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        args = call.arguments;
        return null;
      });

      await FlutterSecureScreen.setBlurIntensity(2.0);
      expect((args as Map)['intensity'], 1.0);

      await FlutterSecureScreen.setBlurIntensity(-0.5);
      expect((args as Map)['intensity'], 0.0);
    });

    test('throws SecureScreenException on platform error', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        throw PlatformException(code: 'ERROR', message: 'Platform failed');
      });

      expect(
        () => FlutterSecureScreen.enableScreenshotBlocking(),
        throwsA(isA<SecureScreenException>().having(
          (e) => e.message,
          'message',
          contains('Platform failed'),
        )),
      );
    });
  });

  group('SecureScreenException', () {
    test('toString returns message', () {
      const message = 'test error';
      expect(
        SecureScreenException(message).toString(),
        'SecureScreenException: $message',
      );
    });
  });
}
