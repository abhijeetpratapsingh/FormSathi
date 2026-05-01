import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/app/app_navigation_shell.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('renders persistent primary tabs and switches tabs', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              AppNavigationShell(currentLocation: state.uri.path, child: child),
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const Text('Home page'),
            ),
            GoRoute(
              path: '/tools',
              builder: (context, state) => const Text('Tools page'),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const Text('Settings page'),
            ),
            GoRoute(
              path: '/my-info',
              builder: (context, state) => const Text('Info page'),
            ),
            GoRoute(
              path: '/documents',
              builder: (context, state) => const Text('Docs page'),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Home page'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings page'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
