import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/document_type.dart';

class DocumentTypePickerSheet extends StatelessWidget {
  const DocumentTypePickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose document type',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Type decides the save details and export actions.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: DocumentType.values.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final type = DocumentType.values[index];
                  return ListTile(
                    leading: Icon(_iconFor(type)),
                    title: Text(type.label),
                    subtitle: Text(_subtitleFor(type)),
                    onTap: () => Navigator.of(context).pop(type),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(DocumentType type) {
    return switch (type) {
      DocumentType.signature => Icons.draw_outlined,
      DocumentType.passportPhoto => Icons.account_box_outlined,
      DocumentType.aadhaar => Icons.badge_outlined,
      DocumentType.pan => Icons.credit_card_outlined,
      DocumentType.marksheet => Icons.school_outlined,
      DocumentType.certificate => Icons.verified_outlined,
      DocumentType.resume => Icons.description_outlined,
      DocumentType.other => Icons.insert_drive_file_outlined,
    };
  }

  String _subtitleFor(DocumentType type) {
    return switch (type) {
      DocumentType.signature => 'Save for under-20KB signature export',
      DocumentType.passportPhoto => 'Save for passport-size photo export',
      DocumentType.aadhaar => 'Front/back ID document',
      DocumentType.pan => 'Front/back PAN record',
      DocumentType.marksheet => 'Education record PDF export',
      DocumentType.certificate => 'Certificate PDF export',
      DocumentType.resume => 'Import a PDF resume',
      DocumentType.other => 'Store a general document',
    };
  }
}
