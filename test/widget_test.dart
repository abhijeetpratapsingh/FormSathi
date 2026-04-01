import 'package:flutter_test/flutter_test.dart';

import 'package:formsathi/app/app.dart';

void main() {
  testWidgets('app builds', (tester) async {
    await tester.pumpWidget(const FormSathiApp());
    expect(find.text('FormSathi'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();
    expect(find.text('My Info'), findsOneWidget);
  });
}
