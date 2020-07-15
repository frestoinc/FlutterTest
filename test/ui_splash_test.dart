import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'file:///C:/Users/root/Documents/AndroidStudioProjects/Projects/flutter_app/lib/ui/splash/splash_page.dart';

void main() {
  testWidgets('Test UI attached', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SplashPage(),
    ));
    await tester.pump(Duration(milliseconds: 2000));
    final bodyFinderPositive = find.text('Flutter Test Demo');
    final bodyFinderNegative = find.text('Android Test Demo');
    await tester.ensureVisible(bodyFinderPositive);
    expect(bodyFinderPositive, findsOneWidget);
    expect(bodyFinderNegative, findsNothing);
  });
}
