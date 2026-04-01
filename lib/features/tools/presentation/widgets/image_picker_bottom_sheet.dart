import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

enum ImageSourceChoice { camera, gallery }

Future<ImageSourceChoice?> showImageSourceBottomSheet(BuildContext context) {
  return showModalBottomSheet<ImageSourceChoice>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop(ImageSourceChoice.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.of(context).pop(ImageSourceChoice.gallery),
            ),
          ],
        ),
      );
    },
  );
}
