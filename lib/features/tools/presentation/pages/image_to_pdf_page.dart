import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../../../core/widgets/section_card.dart';
import '../cubit/image_to_pdf_cubit.dart';
import '../cubit/image_to_pdf_state.dart';
import '../cubit/tools_cubit.dart';
import '../widgets/selected_pdf_images_list.dart';
import '../widgets/tool_section_header.dart';

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
    return AppScaffold(
      title: 'Image to PDF',
      body: BlocConsumer<ImageToPdfCubit, ImageToPdfState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.outputPath != current.outputPath ||
            previous.pdfTitle != current.pdfTitle,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
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
          return ListView(
            children: [
              const ToolSectionHeader(
                title: 'Build a PDF from images',
                subtitle: 'Add multiple pages, reorder them, and create a shareable PDF.',
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.isPicking ? null : () => _selectFromGallery(context),
                      icon: const Icon(Icons.collections_outlined),
                      label: const Text('Add images'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.isPicking ? null : () => context.read<ImageToPdfCubit>().addImageFromCamera(),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Camera'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              SectionCard(
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'PDF name',
                    hintText: 'Enter PDF file name',
                  ),
                  onChanged: (value) => context.read<ImageToPdfCubit>().setTitle(value),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              if (state.hasSelection)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected pages', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSizes.sm),
                    SelectedPdfImagesList(
                      imagePaths: state.imagePaths,
                      onReorder: (oldIndex, newIndex) => context.read<ImageToPdfCubit>().reorderImages(oldIndex, newIndex),
                      onRemove: (index) => context.read<ImageToPdfCubit>().removeImageAt(index),
                    ),
                  ],
                )
              else
                const EmptyStateCard(
                  icon: Icons.picture_as_pdf_outlined,
                  title: 'No images selected',
                  message: 'Add multiple images to create a PDF for form submission.',
                ),
              const SizedBox(height: AppSizes.md),
              FilledButton.icon(
                onPressed: state.isGenerating || !state.hasSelection ? null : () => context.read<ImageToPdfCubit>().generatePdf(),
                icon: state.isGenerating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Generate PDF'),
              ),
              if (state.hasResult) ...[
                const SizedBox(height: AppSizes.md),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PDF saved to device storage', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
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
                                text: 'FormSathi PDF',
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

  Future<void> _selectFromGallery(BuildContext context) async {
    await context.read<ImageToPdfCubit>().addImagesFromGallery();
  }
}
