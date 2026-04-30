import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/image_quality_option.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../cubit/compress_image_cubit.dart';
import '../cubit/compress_image_state.dart';
import '../cubit/tools_cubit.dart';
import '../widgets/image_picker_bottom_sheet.dart';
import '../widgets/resize_quality_chip.dart';
import '../widgets/target_size_selector.dart';
import '../widgets/tool_detail_layout.dart';

class CompressImagePage extends StatelessWidget {
  const CompressImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompressImageCubit, CompressImageState>(
      listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.outputPath != current.outputPath,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<CompressImageCubit>().clearError();
          }
          if (state.hasResult) {
            context.read<ToolsCubit>().refresh();
          }
        },
      builder: (context, state) {
          return ToolDetailsPageTemplate(
            toolTitle: 'Compress Image',
            toolIcon: Icons.compress_rounded,
            toolIconColor: AppColors.warning,
            toolIconBackground: AppColors.warningContainer,
            summary: 'Compress images to reduce file size while preserving quality.',
            usage:
                'Use this when uploads exceed limits or storage is constrained.',
            statusItems: _statusItems(state),
            inlineError: state.errorMessage,
            loadingHint: state.isPicking || state.isCompressing
                ? state.isPicking
                      ? 'Loading source image...'
                      : 'Compressing image, please wait...'
                : null,
            contentCards: [
              ToolDetailPanel(
                title: 'Image source',
                subtitle: 'Pick one image from camera or gallery.',
                icon: Icons.add_photo_alternate_outlined,
                iconColor: AppColors.warning,
                iconBackground: AppColors.warningContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.isCompressing || state.isPicking
                                ? null
                                : () => _selectImage(context),
                            icon: const Icon(Icons.add_a_photo_outlined),
                            label: Text(
                              state.hasSource
                                  ? 'Replace image'
                                  : 'Camera or gallery',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.hasSource) ...[
                      const SizedBox(height: AppSizes.md),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          File(state.sourcePath!),
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        state.sourcePath!.split('/').last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Original size: ${FileSizeFormatter.format(state.originalBytes ?? 0)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              ToolDetailPanel(
                title: 'Compression profile',
                subtitle: 'Choose quality preset to balance clarity and size.',
                icon: Icons.tune_rounded,
                iconColor: AppColors.warning,
                iconBackground: AppColors.warningContainer,
                child: Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: ImageQualityOption.values
                      .map(
                        (quality) => ResizeQualityChip(
                          label: quality.label,
                          selected: state.quality == quality,
                          onTap: () => context
                              .read<CompressImageCubit>()
                              .setQuality(quality),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              ToolDetailPanel(
                title: 'Target size',
                subtitle:
                    'Optionally limit output size for tighter upload constraints.',
                icon: Icons.speed_rounded,
                iconColor: AppColors.warning,
                iconBackground: AppColors.warningContainer,
                child: TargetSizeSelector(
                  selectedKb: state.customTargetBytes == null
                      ? state.quality.targetBytes == null
                            ? null
                            : state.quality.targetBytes! ~/ 1024
                      : state.customTargetBytes! ~/ 1024,
                  onSelected: (kb) =>
                      context.read<CompressImageCubit>().setCustomTargetKb(kb),
                ),
              ),
            ],
            resultCard: state.hasResult
                ? ToolDetailPanel(
                    title: 'Saved result',
                    subtitle: 'Compressed output is available on this device.',
                    icon: Icons.check_circle_rounded,
                    iconColor: AppColors.success,
                    iconBackground: AppColors.successContainer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Final size: ${FileSizeFormatter.format(state.outputBytes ?? 0)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.outputPath ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),
                        OutlinedButton.icon(
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
                          label: const Text('Share output'),
                        ),
                      ],
                    ),
                  )
                : null,
            primaryAction: ToolActionButtonData(
              label:
                  state.isCompressing ? 'Compressing...' : 'Save compressed copy',
              icon: Icons.save_outlined,
              onPressed: state.isCompressing || !state.hasSource
                  ? null
                  : () => context.read<CompressImageCubit>().compressImage(),
              loading: state.isCompressing,
              isPrimary: true,
              enabled: !state.isCompressing && !state.isPicking && state.hasSource,
              semanticLabel: 'Save compressed image',
            ),
            secondaryAction: ToolActionButtonData(
              label: state.hasResult || state.hasSource ? 'Clear' : 'Reset fields',
              icon: Icons.refresh_rounded,
              onPressed: state.hasResult || state.hasSource
                  ? () => context.read<CompressImageCubit>().clearAll()
                  : null,
              enabled:
                  (state.hasResult || state.hasSource) &&
                  !state.isCompressing &&
                  !state.isPicking,
              semanticLabel: 'Clear compressor settings',
            ),
            relatedTools: const [
              ToolRelatedToolItem(
                title: 'Resize Image',
                subtitle: 'Resize first when photos have wrong dimensions.',
                icon: Icons.photo_size_select_actual_rounded,
              ),
              ToolRelatedToolItem(
                title: 'Image to PDF',
                subtitle: 'Combine images after compression into a single PDF.',
                icon: Icons.picture_as_pdf_rounded,
              ),
            ],
            successHint: state.hasResult && !state.isCompressing
                ? 'Compression completed. File is ready to share.'
                : null,
          );
        },
    );
  }

  List<ToolDetailStatusItem> _statusItems(CompressImageState state) {
    return [
      ToolDetailStatusItem(
        label: 'Source',
        value: state.hasSource ? 'Loaded' : 'Waiting',
        icon: state.hasSource ? Icons.check_circle_rounded : Icons.schedule_rounded,
        tone:
            state.hasSource ? ToolDetailStatusTone.success : ToolDetailStatusTone.warning,
      ),
      ToolDetailStatusItem(
        label: 'Quality',
        value: state.quality.label,
        icon: Icons.tune_rounded,
        tone: ToolDetailStatusTone.info,
      ),
      ToolDetailStatusItem(
        label: 'Target',
        value: state.customTargetBytes == null
            ? 'No target'
            : '${(state.customTargetBytes! / 1024).round()} KB',
        icon: Icons.speed_rounded,
        tone: state.customTargetBytes == null
            ? ToolDetailStatusTone.info
            : ToolDetailStatusTone.neutral,
      ),
      if (state.hasResult)
        ToolDetailStatusItem(
          label: 'Output',
          value: FileSizeFormatter.format(state.outputBytes ?? 0),
          icon: Icons.check_circle_outline_rounded,
          tone: ToolDetailStatusTone.success,
        ),
    ];
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
