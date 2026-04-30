import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/document_type.dart';

enum DocumentSourceChoice { camera, gallery, file }

class DocumentSourcePickerSheet extends StatelessWidget {
  const DocumentSourcePickerSheet({required this.documentType, super.key});

  final DocumentType documentType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(documentType.label),
              subtitle: const Text('Choose a source'),
            ),
            if (documentType.supportsCamera)
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded),
                title: const Text('Camera'),
                onTap: () =>
                    Navigator.of(context).pop(DocumentSourceChoice.camera),
              ),
            if (documentType.supportsGallery)
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text('Gallery'),
                onTap: () =>
                    Navigator.of(context).pop(DocumentSourceChoice.gallery),
              ),
            if (documentType.supportsFileImport)
              ListTile(
                leading: const Icon(Icons.upload_file_rounded),
                title: const Text('File'),
                subtitle: Text(
                  documentType == DocumentType.resume
                      ? 'Import a PDF resume'
                      : 'Import an image or PDF',
                ),
                onTap: () =>
                    Navigator.of(context).pop(DocumentSourceChoice.file),
              ),
          ],
        ),
      ),
    );
  }
}
