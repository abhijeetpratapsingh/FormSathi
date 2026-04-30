import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/features/tools/presentation/widgets/custom_dimensions_fields.dart';
import 'package:formsathi/features/tools/presentation/widgets/target_size_selector.dart';

void main() {
  testWidgets('target selector returns selected KB value', (tester) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TargetSizeSelector(
            selectedKb: null,
            onSelected: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Under 50KB'));
    expect(selected, 50);
  });

  testWidgets('custom dimensions fields report width and height', (
    tester,
  ) async {
    int? width;
    int? height;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomDimensionsFields(
            width: null,
            height: null,
            onChanged: (nextWidth, nextHeight) {
              width = nextWidth;
              height = nextHeight;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, '600');
    await tester.enterText(find.byType(TextField).last, '200');

    expect(width, 600);
    expect(height, 200);
  });
}
