import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:formsathi/app/app_navigation_shell.dart';

void main() {
  testWidgets('app shell builds', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppNavigationShell(
          currentLocation: '/home',
          child: Text('Home page'),
        ),
      ),
    );
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
