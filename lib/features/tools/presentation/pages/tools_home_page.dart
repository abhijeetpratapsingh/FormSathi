import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/processed_file.dart';
import '../cubit/compress_image_cubit.dart';
import '../cubit/image_to_pdf_cubit.dart';
import '../cubit/resize_image_cubit.dart';
import '../cubit/tools_cubit.dart';
import '../cubit/tools_state.dart';
import '../widgets/process_preview_dialog.dart';
import '../widgets/recent_processed_file_card.dart';
import '../widgets/tool_action_card.dart';
import '../widgets/tool_section_header.dart';
import 'compress_image_page.dart';
import 'image_to_pdf_page.dart';
import 'resize_image_page.dart';

class ToolsHomePage extends StatelessWidget {
  const ToolsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Tools',
      body: BlocConsumer<ToolsCubit, ToolsState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<ToolsCubit>().clearError();
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              SectionCard(
                gradient: AppColors.primaryGradient(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tagline,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.homeSubtitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Resize, compress, and create PDFs without internet or signup.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              ToolActionCard(
                title: 'Resize Image',
                subtitle:
                    'Passport size, signature size, and target file sizes',
                icon: Icons.photo_size_select_actual_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<ToolsCubit>()),
                        BlocProvider.value(
                          value: context.read<ResizeImageCubit>(),
                        ),
                      ],
                      child: const ResizeImagePage(),
                    ),
                  ),
                ),
              ),
              ToolActionCard(
                title: 'Compress Image',
                subtitle: 'High, medium, or low compression for form uploads',
                icon: Icons.compress_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<ToolsCubit>()),
                        BlocProvider.value(
                          value: context.read<CompressImageCubit>(),
                        ),
                      ],
                      child: const CompressImagePage(),
                    ),
                  ),
                ),
              ),
              ToolActionCard(
                title: 'Image to PDF',
                subtitle:
                    'Select multiple images, reorder them, and create a PDF',
                icon: Icons.picture_as_pdf_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<ToolsCubit>()),
                        BlocProvider.value(
                          value: context.read<ImageToPdfCubit>(),
                        ),
                      ],
                      child: const ImageToPdfPage(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              ToolSectionHeader(
                title: 'Recent processed files',
                subtitle: 'Your last saved outputs stay on this device.',
                trailing: TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () => context.read<ToolsCubit>().refresh(),
                  child: const Text('Refresh'),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              if (state.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state.recentFiles.isEmpty)
                const EmptyStateCard(
                  icon: Icons.folder_open_outlined,
                  title: 'No processed files yet',
                  message: AppStrings.toolsEmpty,
                )
              else
                ...state.recentFiles.map(
                  (file) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: RecentProcessedFileCard(
                      file: file,
                      onTap: () => showProcessedFilePreviewDialog(
                        context,
                        file,
                        onShare: () => _shareFile(file),
                        onDelete: () => _confirmDelete(context, file),
                      ),
                      onShare: () => _shareFile(file),
                      onDelete: () => _confirmDelete(context, file),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _shareFile(ProcessedFile file) {
    SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.localPath)],
        text: file.metadata['title'] ?? file.type.label,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, ProcessedFile file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete file?'),
          content: const Text(
            'This will remove the file from your device storage.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed == true && context.mounted) {
      await context.read<ToolsCubit>().deleteFile(file);
    }
  }
}
