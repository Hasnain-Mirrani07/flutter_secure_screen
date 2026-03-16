import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_secure_screen_example/main.dart';

void main() {
  testWidgets('App loads and shows secure screen title', (WidgetTester tester) async {
    await tester.pumpWidget(const SecureScreenExampleApp());
    expect(find.text('Flutter Secure Screen'), findsOneWidget);
    expect(find.text('Secure Screen Protection'), findsOneWidget);
  });
}
