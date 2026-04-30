import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/utils/sensitive_value_formatter.dart';

void main() {
  test('masks Aadhaar and PAN values in last-4 style', () {
    expect(SensitiveValueFormatter.maskLast4('123456789012'), '•••• 9012');
    expect(SensitiveValueFormatter.maskLast4('ABCDE1234F'), '•••• 234F');
  });

  test('leaves empty and short values readable', () {
    expect(SensitiveValueFormatter.maskLast4(''), '');
    expect(SensitiveValueFormatter.maskLast4('1234'), '1234');
  });
}
