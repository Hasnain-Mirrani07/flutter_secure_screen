import 'package:flutter/services.dart';

/// Screenshot and screen recording guard for fintech apps.
///
/// Use cases:
/// - Banking apps
/// - Wallet apps
/// - Password managers
///
/// Features:
/// - Disable screenshots
/// - Disable screen recording
/// - Blur app when in background
class FlutterScreenshotGuard {
  static const MethodChannel _channel =
      MethodChannel('flutter_screenshot_guard');

  /// Enables secure mode which disables screenshots and screen recording.
  ///
  /// **Android**: Sets [FLAG_SECURE](https://developer.android.com/reference/android/view/WindowManager.LayoutParams#FLAG_SECURE)
  /// on the activity window, preventing screenshots and screen recording.
  ///
  /// **iOS**: Screenshots cannot be fully prevented by the system.
  /// This enables blur overlay when app goes to background/recording,
  /// obscuring sensitive content from screenshots and screen recordings.
  static Future<void> enableScreenshotBlocking() async {
    try {
      await _channel.invokeMethod<void>('enableScreenshotBlocking');
    } on PlatformException catch (e) {
      throw ScreenshotGuardException(e.message ?? e.toString());
    }
  }

  /// Disables screenshot blocking.
  static Future<void> disableScreenshotBlocking() async {
    try {
      await _channel.invokeMethod<void>('disableScreenshotBlocking');
    } on PlatformException catch (e) {
      throw ScreenshotGuardException(e.message ?? e.toString());
    }
  }

  /// Enables blur overlay when app goes to background.
  ///
  /// When the user switches away from your app (e.g., app switcher, home button),
  /// a blur overlay is shown to prevent sensitive content from being visible.
  /// This protects against shoulder surfing and accidental exposure.
  static Future<void> enableBlurOnBackground() async {
    try {
      await _channel.invokeMethod<void>('enableBlurOnBackground');
    } on PlatformException catch (e) {
      throw ScreenshotGuardException(e.message ?? e.toString());
    }
  }

  /// Disables blur on background.
  static Future<void> disableBlurOnBackground() async {
    try {
      await _channel.invokeMethod<void>('disableBlurOnBackground');
    } on PlatformException catch (e) {
      throw ScreenshotGuardException(e.message ?? e.toString());
    }
  }

  /// Enables all secure screen protections.
  ///
  /// Equivalent to calling [enableScreenshotBlocking] and [enableBlurOnBackground].
  static Future<void> enableSecureMode() async {
    try {
      await _channel.invokeMethod<void>('enableSecureMode');
    } on PlatformException catch (e) {
      throw ScreenshotGuardException(e.message ?? e.toString());
    }
  }

  /// Disables all secure screen protections.
  static Future<void> disableSecureMode() async {
    try {
      await _channel.invokeMethod<void>('disableSecureMode');
    } on PlatformException catch (e) {
      throw ScreenshotGuardException(e.message ?? e.toString());
    }
  }

  /// Sets a custom blur intensity when app is in background.
  ///
  /// [intensity] should be between 0.0 and 1.0 (default is 0.5).
  /// Only applies when blur on background is enabled.
  static Future<void> setBlurIntensity(double intensity) async {
    try {
      await _channel.invokeMethod<void>(
        'setBlurIntensity',
        {'intensity': intensity.clamp(0.0, 1.0)},
      );
    } on PlatformException catch (e) {
      throw ScreenshotGuardException(e.message ?? e.toString());
    }
  }
}

/// Exception thrown when screenshot guard operations fail.
class ScreenshotGuardException implements Exception {
  final String message;
  ScreenshotGuardException(this.message);

  @override
  String toString() => 'ScreenshotGuardException: $message';
}
