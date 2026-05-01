import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/app/router.dart';

void main() {
  test('primary tabs are Home, Tools, and Settings routes', () {
    expect(AppRouter.primaryTabLocations, [
      '/home',
      '/tools',
      '/settings',
    ]);
  });
}
