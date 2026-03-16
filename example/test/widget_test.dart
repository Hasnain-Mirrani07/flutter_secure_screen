import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_screenshot_guard_example/main.dart';

void main() {
  testWidgets('App loads and shows screenshot guard title', (WidgetTester tester) async {
    await tester.pumpWidget(const ScreenshotGuardExampleApp());
    expect(find.text('Flutter Screenshot Guard'), findsOneWidget);
    expect(find.text('Secure Screen Protection'), findsOneWidget);
  });
}
