import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/image_quality_option.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../../../core/widgets/section_card.dart';
import '../cubit/compress_image_cubit.dart';
import '../cubit/compress_image_state.dart';
import '../cubit/tools_cubit.dart';
import '../widgets/image_picker_bottom_sheet.dart';
import '../widgets/resize_quality_chip.dart';
import '../widgets/tool_section_header.dart';

class CompressImagePage extends StatelessWidget {
  const CompressImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Compress Image',
      body: BlocConsumer<CompressImageCubit, CompressImageState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage || previous.outputPath != current.outputPath,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<CompressImageCubit>().clearError();
          }
          if (state.hasResult) {
            context.read<ToolsCubit>().refresh();
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              const ToolSectionHeader(
                title: 'Select an image',
                subtitle: 'Compress for quicker uploads and smaller storage.',
              ),
              const SizedBox(height: AppSizes.sm),
              OutlinedButton.icon(
                onPressed: state.isPicking ? null : () => _selectImage(context),
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Camera / Gallery'),
              ),
              const SizedBox(height: AppSizes.md),
              if (state.hasSource)
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          File(state.outputPath ?? state.sourcePath!),
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(state.sourcePath!.split('/').last, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Original size: ${FileSizeFormatter.format(state.originalBytes ?? 0)}'),
                    ],
                  ),
                )
              else
                const EmptyStateCard(
                  icon: Icons.compress_outlined,
                  title: 'No image selected',
                  message: 'Choose a photo to compress for form uploads.',
                ),
              const SizedBox(height: AppSizes.md),
              const ToolSectionHeader(
                title: 'Quality',
                subtitle: 'Trade off size and visual quality.',
              ),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: ImageQualityOption.values
                    .map(
                      (quality) => ResizeQualityChip(
                        label: quality.label,
                        selected: state.quality == quality,
                        onTap: () => context.read<CompressImageCubit>().setQuality(quality),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: AppSizes.md),
              FilledButton.icon(
                onPressed: state.isCompressing || !state.hasSource ? null : () => context.read<CompressImageCubit>().compressImage(),
                icon: state.isCompressing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Save compressed copy'),
              ),
              if (state.hasResult) ...[
                const SizedBox(height: AppSizes.md),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saved to device storage', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('Final size: ${FileSizeFormatter.format(state.outputBytes ?? 0)}'),
                      const SizedBox(height: 4),
                      Text(state.outputPath ?? ''),
                      const SizedBox(height: AppSizes.md),
                      FilledButton.icon(
                        onPressed: () {
                          final path = state.outputPath;
                          if (path != null) {
                            SharePlus.instance.share(
                              ShareParams(
                                files: [XFile(path)],
                                text: 'FormSathi compressed image',
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectImage(BuildContext context) async {
    final choice = await showImageSourceBottomSheet(context);
    if (!context.mounted || choice == null) return;
    if (choice == ImageSourceChoice.camera) {
      await context.read<CompressImageCubit>().pickFromCamera();
    } else {
      await context.read<CompressImageCubit>().pickFromGallery();
    }
  }
}
