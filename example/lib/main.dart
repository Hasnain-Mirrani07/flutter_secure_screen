import 'package:flutter/material.dart';
import 'package:flutter_screenshot_guard/flutter_screenshot_guard.dart';

void main() {
  runApp(const ScreenshotGuardExampleApp());
}

class ScreenshotGuardExampleApp extends StatelessWidget {
  const ScreenshotGuardExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Screenshot Guard Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _secureModeEnabled = true;
  bool _screenshotBlockingEnabled = true;
  bool _blurOnBackgroundEnabled = true;
  double _blurIntensity = 0.5;

  @override
  void initState() {
    super.initState();
    _enableSecureMode();
  }

  Future<void> _enableSecureMode() async {
    await FlutterScreenshotGuard.enableSecureMode();
    setState(() {
      _secureModeEnabled = true;
      _screenshotBlockingEnabled = true;
      _blurOnBackgroundEnabled = true;
    });
  }

  Future<void> _disableSecureMode() async {
    await FlutterScreenshotGuard.disableSecureMode();
    setState(() {
      _secureModeEnabled = false;
      _screenshotBlockingEnabled = false;
      _blurOnBackgroundEnabled = false;
    });
  }

  Future<void> _toggleScreenshotBlocking(bool value) async {
    if (value) {
      await FlutterScreenshotGuard.enableScreenshotBlocking();
    } else {
      await FlutterScreenshotGuard.disableScreenshotBlocking();
    }
    setState(() => _screenshotBlockingEnabled = value);
  }

  Future<void> _toggleBlurOnBackground(bool value) async {
    if (value) {
      await FlutterScreenshotGuard.enableBlurOnBackground();
    } else {
      await FlutterScreenshotGuard.disableBlurOnBackground();
    }
    setState(() => _blurOnBackgroundEnabled = value);
  }

  Future<void> _setBlurIntensity(double value) async {
    await FlutterScreenshotGuard.setBlurIntensity(value);
    setState(() => _blurIntensity = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Screenshot Guard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildSensitiveDataCard(),
            const SizedBox(height: 24),
            _buildControlsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.teal.shade700, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Secure Screen Protection',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This demo shows flutter_screenshot_guard features:\n'
              '• Disable screenshots (Android) / blur when recording (iOS)\n'
              '• Disable screen recording\n'
              '• Blur app when in background or app switcher',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensitiveDataCard() {
    return Card(
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Simulated Sensitive Data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDataRow('Account Number', '**** **** **** 4521'),
            _buildDataRow('Balance', '\$12,450.00'),
            _buildDataRow('Last Login', 'March 16, 2025'),
            const SizedBox(height: 8),
            Text(
              'Switch to another app or take a screenshot to see the protection in action.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildControlsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Controls',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Screenshot blocking'),
              subtitle: const Text(
                'Prevents screenshots and screen recording',
              ),
              value: _screenshotBlockingEnabled,
              onChanged: _toggleScreenshotBlocking,
            ),
            SwitchListTile(
              title: const Text('Blur on background'),
              subtitle: const Text(
                'Blurs app when switched away or in app switcher',
              ),
              value: _blurOnBackgroundEnabled,
              onChanged: _toggleBlurOnBackground,
            ),
            const SizedBox(height: 16),
            Text(
              'Blur intensity',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: _blurIntensity,
              onChanged: (value) => _setBlurIntensity(value),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.icon(
                  onPressed: _secureModeEnabled ? null : _enableSecureMode,
                  icon: const Icon(Icons.lock),
                  label: const Text('Enable All'),
                ),
                FilledButton.tonalIcon(
                  onPressed: _secureModeEnabled ? _disableSecureMode : null,
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Disable All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
