import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/enums/document_type.dart';
import 'package:formsathi/core/services/local_file_service.dart';
import 'package:formsathi/features/documents/presentation/widgets/document_metadata_review_sheet.dart';
import 'package:formsathi/features/documents/presentation/widgets/document_type_picker_sheet.dart';

void main() {
  testWidgets('type picker returns selected document type', (tester) async {
    DocumentType? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              selected = await showModalBottomSheet<DocumentType>(
                context: context,
                builder: (_) => const DocumentTypePickerSheet(),
              );
            },
            child: const Text('Add'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Signature'));
    await tester.pumpAndSettle();

    expect(selected, DocumentType.signature);
  });

  testWidgets('metadata review captures side and notes', (tester) async {
    DocumentMetadataReviewResult? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showModalBottomSheet<DocumentMetadataReviewResult>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const DocumentMetadataReviewSheet(
                  documentType: DocumentType.aadhaar,
                  sourcePath: '/tmp/aadhaar.jpg',
                  initialTitle: 'Aadhaar',
                  metadata: FileMetadata(
                    fileSizeBytes: 1024,
                    originalFileName: 'aadhaar.jpg',
                    mimeType: 'image/jpeg',
                    width: 100,
                    height: 200,
                  ),
                ),
              );
            },
            child: const Text('Review'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Updated address');
    await tester.tap(find.text('Save document'));
    await tester.pumpAndSettle();

    expect(result?.title, 'Aadhaar');
    expect(result?.side.label, 'Front');
    expect(result?.notes, 'Updated address');
  });
}
