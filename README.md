# flutter_secure_screen

[![pub package](https://img.shields.io/pub/v/flutter_secure_screen.svg)](https://pub.dev/packages/flutter_secure_screen)

**Secure screenshot and screen recording protection for Flutter apps.**  
Essential for **banking**, **wallet**, **password manager**, and other fintech apps that must prevent screenshots, screen recording, and visible content in the app switcher.

## Features

| Feature | Android | iOS |
|--------|---------|-----|
| **Disable screenshots** | ✅ `FLAG_SECURE` | ⚠️ Blur overlay when recording/background |
| **Disable screen recording** | ✅ `FLAG_SECURE` | ✅ Blur overlay when capture is active |
| **Blur app when in background** | ✅ Dim overlay in recents | ✅ Blur overlay in app switcher |

- **Android**: Uses `WindowManager.LayoutParams.FLAG_SECURE` to block screenshots and screen recording system-wide.
- **iOS**: Screenshots cannot be fully disabled by the system. The plugin shows a **blur overlay** when the app is backgrounded or when screen capture/recording is detected (iOS 11+), so sensitive content is never visible in the app switcher or in recordings.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_secure_screen: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Enable all protections (recommended for fintech)

```dart
import 'package:flutter_secure_screen/flutter_secure_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterSecureScreen.enableSecureMode();
  runApp(MyApp());
}
```

### Enable / disable individually

```dart
// Block screenshots and screen recording (Android: FLAG_SECURE; iOS: blur when recording)
await FlutterSecureScreen.enableScreenshotBlocking();
await FlutterSecureScreen.disableScreenshotBlocking();

// Blur app when in background (app switcher / recents)
await FlutterSecureScreen.enableBlurOnBackground();
await FlutterSecureScreen.disableBlurOnBackground();
```

### Optional: blur intensity

When using blur on background, you can set intensity (0.0–1.0, default 0.5):

```dart
await FlutterSecureScreen.setBlurIntensity(0.7);
```

## Use cases

- **Banking apps** – Protect account and balance from screenshots and shoulder surfing.
- **Wallet / crypto apps** – Keep keys and balances private in recents and recordings.
- **Password managers** – Prevent passwords from appearing in app switcher or screen capture.

## Platform details

### Android

- **minSdk**: 24  
- Screenshot and screen recording are disabled via `FLAG_SECURE`.  
- Background blur is a semi-transparent overlay shown when the app is in recents.

### iOS

- **iOS 11+** for screen capture detection (`UIScreen.isCaptured`).  
- **iOS 13+** recommended for key window resolution.  
- Blur overlay is shown when the app goes to background or when screen capture/recording is active.

## Example

See the `example/` app for a full demo with toggles for each feature and simulated sensitive data.

```bash
cd example && flutter run
```

## License

See [LICENSE](LICENSE) for details.
