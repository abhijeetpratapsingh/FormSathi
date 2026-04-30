import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../core/widgets/section_card.dart';
import '../cubit/image_to_pdf_cubit.dart';
import '../cubit/image_to_pdf_state.dart';
import '../cubit/tools_cubit.dart';
import '../widgets/selected_pdf_images_list.dart';
import '../widgets/tool_detail_layout.dart';
import '../widgets/target_size_selector.dart';

class ImageToPdfPage extends StatefulWidget {
  const ImageToPdfPage({super.key});

  @override
  State<ImageToPdfPage> createState() => _ImageToPdfPageState();
}

class _ImageToPdfPageState extends State<ImageToPdfPage> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'form_sathi_document');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageToPdfCubit, ImageToPdfState>(
      listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.outputPath != current.outputPath ||
            previous.pdfTitle != current.pdfTitle,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<ImageToPdfCubit>().clearError();
          }
          if (state.hasResult) {
            context.read<ToolsCubit>().refresh();
          }
          if (_titleController.text != state.pdfTitle) {
            _titleController.value = _titleController.value.copyWith(
              text: state.pdfTitle,
              selection: TextSelection.collapsed(offset: state.pdfTitle.length),
            );
          }
        },
        builder: (context, state) {
          return ToolDetailsPageTemplate(
            toolTitle: 'Image to PDF',
            toolIcon: Icons.picture_as_pdf_rounded,
            toolIconColor: AppColors.accent,
            toolIconBackground: AppColors.muted,
            summary: 'Build a single PDF from multiple images for secure submission.',
            usage:
                'Add pages, reorder where needed, then generate a consolidated file.',
            statusItems: _statusItems(state),
            inlineError: state.errorMessage,
            loadingHint: state.isPicking || state.isGenerating
                ? state.isPicking
                      ? 'Loading selected images...'
                      : 'Generating PDF, please wait...'
                : null,
            contentCards: [
              ToolDetailPanel(
                title: 'Source images',
                subtitle: 'Add one or more images to assemble the document.',
                icon: Icons.collections_outlined,
                iconColor: AppColors.accent,
                iconBackground: AppColors.muted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.isPicking || state.isGenerating
                                ? null
                                : () => _selectFromGallery(context),
                            icon: const Icon(Icons.collections_outlined),
                            label: const Text('Add images'),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.isPicking || state.isGenerating
                                ? null
                                : () => context
                                    .read<ImageToPdfCubit>()
                                    .addImageFromCamera(),
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: const Text('Camera'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    if (state.hasSelection) ...[
                      Text(
                        'Selected pages',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      SelectedPdfImagesList(
                        imagePaths: state.imagePaths,
                        onReorder: (oldIndex, newIndex) => context
                            .read<ImageToPdfCubit>()
                            .reorderImages(oldIndex, newIndex),
                        onRemove: (index) =>
                            context.read<ImageToPdfCubit>().removeImageAt(index),
                      ),
                    ] else ...[
                      Text(
                        'No images selected yet. Add at least one image to start. ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              ToolDetailPanel(
                title: 'Document title',
                subtitle: 'Use a clear name for easy retrieval and sharing.',
                icon: Icons.edit_outlined,
                iconColor: AppColors.accent,
                iconBackground: AppColors.muted,
                child: SectionCard(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'PDF name',
                      hintText: 'Enter PDF file name',
                    ),
                    onChanged: (value) =>
                        context.read<ImageToPdfCubit>().setTitle(value),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              ToolDetailPanel(
                title: 'Target size',
                subtitle:
                    'Set a file-size target when PDF must stay within limits.',
                icon: Icons.speed_rounded,
                iconColor: AppColors.accent,
                iconBackground: AppColors.muted,
                child: TargetSizeSelector(
                  selectedKb: state.targetBytes == null
                      ? null
                      : state.targetBytes! ~/ 1024,
                  onSelected: (kb) =>
                      context.read<ImageToPdfCubit>().setTargetKb(kb),
                ),
              ),
            ],
            resultCard: state.hasResult
                ? ToolDetailPanel(
                    title: 'Saved result',
                    subtitle: 'PDF created and written to local storage.',
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
                        if (state.outputWarning != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            state.outputWarning!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
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
                                  text: 'FormSathi PDF',
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
              label: state.isGenerating ? 'Generating...' : 'Generate PDF',
              icon: Icons.description_outlined,
              onPressed: state.isGenerating || !state.hasSelection
                  ? null
                  : () => context.read<ImageToPdfCubit>().generatePdf(),
              loading: state.isGenerating,
              isPrimary: true,
              enabled:
                  !state.isGenerating &&
                  !state.isPicking &&
                  state.hasSelection,
              semanticLabel: 'Generate PDF from selected images',
            ),
            secondaryAction: ToolActionButtonData(
              label: state.hasResult || state.hasSelection
                  ? 'Clear'
                  : 'Reset fields',
              icon: Icons.refresh_rounded,
              onPressed: state.hasResult || state.hasSelection
                  ? () => context.read<ImageToPdfCubit>().clearAll()
                  : null,
              enabled:
                  (state.hasResult || state.hasSelection) &&
                  !state.isGenerating &&
                  !state.isPicking,
              semanticLabel: 'Clear PDF workflow',
            ),
            relatedTools: const [
              ToolRelatedToolItem(
                title: 'Resize Image',
                subtitle: 'Resize source images before composing PDF pages.',
                icon: Icons.photo_size_select_actual_rounded,
              ),
              ToolRelatedToolItem(
                title: 'Compress Image',
                subtitle: 'Compress pages first to stay under delivery size limits.',
                icon: Icons.compress_rounded,
              ),
            ],
            successHint: state.hasResult && !state.isGenerating
                ? 'PDF generated successfully and ready to share.'
                : null,
          );
        },
      );
  }

  List<ToolDetailStatusItem> _statusItems(ImageToPdfState state) {
    return [
      ToolDetailStatusItem(
        label: 'Pages',
        value: '${state.imagePaths.length}',
        icon: Icons.collections_bookmark_outlined,
        tone: state.imagePaths.isNotEmpty
            ? ToolDetailStatusTone.success
            : ToolDetailStatusTone.warning,
      ),
      ToolDetailStatusItem(
        label: 'Preset',
        value: state.targetBytes == null
            ? 'No size limit'
            : '${(state.targetBytes! / 1024).round()} KB',
        icon: Icons.speed_rounded,
        tone: state.targetBytes == null
            ? ToolDetailStatusTone.info
            : ToolDetailStatusTone.neutral,
      ),
      ToolDetailStatusItem(
        label: 'Title',
        value: state.pdfTitle.trim().isEmpty
            ? 'Unnamed'
            : state.pdfTitle,
        icon: Icons.text_fields_rounded,
        tone: ToolDetailStatusTone.info,
      ),
      if (state.hasResult)
        ToolDetailStatusItem(
          label: 'Output',
          value: FileSizeFormatter.format(state.outputBytes ?? 0),
          icon: Icons.picture_as_pdf_outlined,
          tone: state.outputWarning == null
              ? ToolDetailStatusTone.success
              : ToolDetailStatusTone.warning,
        ),
    ];
  }

  Future<void> _selectFromGallery(BuildContext context) async {
    await context.read<ImageToPdfCubit>().addImagesFromGallery();
  }
}
