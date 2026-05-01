import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('home shows Info and Docs entry points', (tester) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/my-info',
          builder: (context, state) => const Scaffold(body: Text('Info page')),
        ),
        GoRoute(
          path: '/documents',
          builder: (context, state) => const Scaffold(body: Text('Docs page')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Info'), findsOneWidget);
    expect(find.text('Docs'), findsOneWidget);
    expect(find.text('Tools'), findsNothing);
    expect(find.text('Settings'), findsNothing);

    await tester.tap(find.text('Info'));
    await tester.pumpAndSettle();
    expect(find.text('Info page'), findsOneWidget);
  });
}
