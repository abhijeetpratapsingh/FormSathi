import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/app/router.dart';

void main() {
  test('primary tabs are Info, Docs, Tools, and Settings routes', () {
    expect(AppRouter.primaryTabLocations, [
      '/my-info',
      '/documents',
      '/tools',
      '/settings',
    ]);
  });
}
