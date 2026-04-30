import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/resize_preset.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../cubit/resize_image_cubit.dart';
import '../cubit/resize_image_state.dart';
import '../cubit/tools_cubit.dart';
import '../widgets/custom_dimensions_fields.dart';
import '../widgets/image_picker_bottom_sheet.dart';
import '../widgets/preset_chip.dart';
import '../widgets/target_size_selector.dart';
import '../widgets/tool_detail_layout.dart';

class ResizeImagePage extends StatelessWidget {
  const ResizeImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResizeImageCubit, ResizeImageState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.outputPath != current.outputPath,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<ResizeImageCubit>().clearError();
        }
        if (state.hasResult) {
          context.read<ToolsCubit>().refresh();
        }
      },
      builder: (context, state) {
        return ToolDetailsPageTemplate(
          toolTitle: 'Resize Image',
          toolIcon: Icons.photo_size_select_actual_rounded,
          toolIconColor: AppColors.primary,
          toolIconBackground: AppColors.infoContainer,
          summary: 'Resize source images to standard dimensions or custom values.',
          usage:
              'Use this tool when uploaded photos must match exact form requirements.',
          statusItems: _statusItems(context, state),
          inlineError: state.errorMessage,
          loadingHint: state.isPicking
              ? 'Loading image source...'
              : null,
          contentCards: [
            ToolDetailPanel(
              title: 'Image source',
              subtitle:
                  'Pick one image using your camera or existing photos.',
              icon: Icons.add_photo_alternate_outlined,
              iconColor: AppColors.primary,
              iconBackground: AppColors.infoContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!state.hasSource) ...[
                    Text(
                      'No image selected.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: state.isProcessing || state.isPicking
                              ? null
                              : () => _selectImage(context),
                          icon: const Icon(Icons.add_a_photo_outlined),
                          label: Text(
                            state.hasSource ? 'Replace image' : 'Camera / Gallery',
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
                        File(state.outputPath ?? state.sourcePath!),
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
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
              title: 'Resize options',
              subtitle: 'Choose a standard profile or define pixel values.',
              icon: Icons.tune_rounded,
              iconColor: AppColors.primary,
              iconBackground: AppColors.infoContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSizes.sm,
                    runSpacing: AppSizes.sm,
                    children: ResizePreset.values
                        .map(
                          (preset) => PresetChip(
                            label: preset.label,
                            selected: state.preset == preset,
                            onTap: () =>
                                context.read<ResizeImageCubit>().setPreset(preset),
                          ),
                        )
                        .toList(growable: false),
                  ),
                  if (state.preset == ResizePreset.custom) ...[
                    const SizedBox(height: AppSizes.sm),
                    CustomDimensionsFields(
                      width: state.customWidth,
                      height: state.customHeight,
                      onChanged: (width, height) => context
                          .read<ResizeImageCubit>()
                          .setCustomDimensions(width: width, height: height),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            ToolDetailPanel(
              title: 'Target size',
              subtitle: 'Optional output cap for tighter delivery constraints.',
              icon: Icons.speed_rounded,
              iconColor: AppColors.primary,
              iconBackground: AppColors.infoContainer,
              child: TargetSizeSelector(
                selectedKb: state.customTargetBytes == null
                    ? state.preset.targetBytes == null
                    ? null
                    : state.preset.targetBytes! ~/ 1024
                    : state.customTargetBytes! ~/ 1024,
                onSelected: (kb) =>
                    context.read<ResizeImageCubit>().setCustomTargetKb(kb),
              ),
            ),
            if (state.hasResult)
              const SizedBox(height: AppSizes.lg)
            else
              const SizedBox.shrink(),
          ],
          resultCard: state.hasResult
              ? ToolDetailPanel(
                  title: 'Saved result',
                  subtitle: 'Output has been written to local storage.',
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
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        state.outputPath ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final path = state.outputPath;
                            if (path != null) {
                              SharePlus.instance.share(
                                ShareParams(
                                  files: [XFile(path)],
                                  text: 'FormSathi resized image',
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Share output'),
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          primaryAction: ToolActionButtonData(
            label: state.isProcessing ? 'Resizing...' : 'Save resized copy',
            icon: Icons.save_outlined,
            onPressed: state.isProcessing || !state.hasSource
                ? null
                : () => context.read<ResizeImageCubit>().processImage(),
            loading: state.isProcessing,
            isPrimary: true,
            enabled: !state.isProcessing && !state.isPicking && state.hasSource,
            semanticLabel: 'Save resized image to device',
          ),
          secondaryAction: ToolActionButtonData(
            label: state.hasResult || state.hasSource ? 'Clear' : 'Reset fields',
            icon: Icons.refresh_rounded,
            onPressed: state.hasResult || state.hasSource
                ? () => context.read<ResizeImageCubit>().clearAll()
                : () {},
            enabled: (state.hasSource || state.hasResult) &&
                !state.isProcessing &&
                !state.isPicking,
            semanticLabel: 'Clear source and output',
          ),
          relatedTools: const [
            ToolRelatedToolItem(
              title: 'Compress Image',
              subtitle: 'Next step: reduce final output weight.',
              icon: Icons.compress_rounded,
            ),
            ToolRelatedToolItem(
              title: 'Image to PDF',
              subtitle: 'Use with multiple signatures and photos together.',
              icon: Icons.picture_as_pdf_rounded,
            ),
          ],
          headerActions: [
            IconButton(
              tooltip: 'Open source',
              onPressed: state.isPicking || state.isProcessing
                  ? null
                  : () => _selectImage(context),
              constraints: const BoxConstraints(
                minWidth: AppSizes.minTouchTarget,
                minHeight: AppSizes.minTouchTarget,
              ),
              icon: const Icon(Icons.add_a_photo_outlined),
            ),
          ],
        );
      },
    );
  }

  List<ToolDetailStatusItem> _statusItems(
    BuildContext context,
    ResizeImageState state,
  ) {
    return [
      ToolDetailStatusItem(
        label: 'Source',
        value: state.hasSource ? 'Loaded' : 'Waiting',
        icon:
            state.hasSource ? Icons.check_circle_rounded : Icons.warning_rounded,
        tone: state.hasSource
            ? ToolDetailStatusTone.success
            : ToolDetailStatusTone.warning,
      ),
      ToolDetailStatusItem(
        label: 'Preset',
        value: state.preset == ResizePreset.custom
            ? 'Custom'
            : state.preset.label,
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
      await context.read<ResizeImageCubit>().pickFromCamera();
    } else {
      await context.read<ResizeImageCubit>().pickFromGallery();
    }
  }
}
