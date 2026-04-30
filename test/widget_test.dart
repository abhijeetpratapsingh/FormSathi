import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:formsathi/app/app_navigation_shell.dart';

void main() {
  testWidgets('app shell builds', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppNavigationShell(
          currentLocation: '/my-info',
          child: Text('Info page'),
        ),
      ),
    );
    expect(find.text('Info'), findsOneWidget);
    expect(find.text('Docs'), findsOneWidget);
  });
}
