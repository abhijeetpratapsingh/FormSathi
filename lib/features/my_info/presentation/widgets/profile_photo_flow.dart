import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

Future<String?> pickProfilePhoto(BuildContext context) async {
  final navigator = Navigator.of(context);
  final choice = await showModalBottomSheet<_AvatarAction>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _AvatarActionSheet(),
  );
  if (choice == null) return null;
  if (choice == _AvatarAction.remove) return '';

  final source = choice == _AvatarAction.camera
      ? ImageSource.camera
      : ImageSource.gallery;
  final imagePicker = ImagePicker();
  final picked = await imagePicker.pickImage(
    source: source,
    imageQuality: 88,
    maxWidth: 1024,
    maxHeight: 1024,
  );
  if (picked == null) return null;

  final croppedBytes = await navigator.push<Uint8List>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _ProfilePhotoCropPage(
        imageBytes: File(picked.path).readAsBytesSync(),
      ),
    ),
  );
  if (croppedBytes == null) return null;
  return _saveProfilePhotoBytes(croppedBytes);
}

Future<String> _saveProfilePhotoBytes(Uint8List bytes) async {
  final baseDir = await getApplicationDocumentsDirectory();
  final directory = Directory(p.join(baseDir.path, 'app_data', 'profile'));
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  final destination = File(
    p.join(
      directory.path,
      'profile_${DateTime.now().millisecondsSinceEpoch}.png',
    ),
  );
  await destination.writeAsBytes(bytes, flush: true);
  return destination.path;
}

enum _AvatarAction { camera, gallery, remove }

class _AvatarActionSheet extends StatelessWidget {
  const _AvatarActionSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.xs,
          AppSizes.md,
          AppSizes.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.of(context).pop(_AvatarAction.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.of(context).pop(_AvatarAction.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Remove photo'),
              onTap: () => Navigator.of(context).pop(_AvatarAction.remove),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePhotoCropPage extends StatefulWidget {
  const _ProfilePhotoCropPage({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<_ProfilePhotoCropPage> createState() => _ProfilePhotoCropPageState();
}

class _ProfilePhotoCropPageState extends State<_ProfilePhotoCropPage> {
  final _cropController = CropController();
  bool _isCropping = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Position Photo'),
        leading: IconButton(
          tooltip: 'Cancel',
          onPressed: _isCropping ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSizes.sm),
            child: FilledButton(
              onPressed: _isCropping ? null : _applyCrop,
              child: _isCropping
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Apply'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.surfaceAlt,
                child: Crop(
                  image: widget.imageBytes,
                  controller: _cropController,
                  aspectRatio: 1,
                  withCircleUi: true,
                  interactive: true,
                  fixCropRect: true,
                  initialRectBuilder: InitialRectBuilder.withSizeAndRatio(
                    size: 0.82,
                    aspectRatio: 1,
                  ),
                  baseColor: AppColors.surfaceAlt,
                  maskColor: Colors.black.withValues(alpha: 0.56),
                  progressIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onCropped: (result) {
                    if (!mounted) return;
                    setState(() => _isCropping = false);
                    switch (result) {
                      case CropSuccess(:final croppedImage):
                        Navigator.of(context).pop(croppedImage);
                      case CropFailure():
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not crop selected photo.'),
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.sm,
                AppSizes.md,
                AppSizes.md,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      'Drag to position and pinch to zoom inside the profile circle.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyCrop() {
    setState(() => _isCropping = true);
    _cropController.cropCircle();
  }
}
