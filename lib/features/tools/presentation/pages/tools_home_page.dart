import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_top_header.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../domain/entities/processed_file.dart';
import '../cubit/compress_image_cubit.dart';
import '../cubit/image_to_pdf_cubit.dart';
import '../cubit/resize_image_cubit.dart';
import '../cubit/tools_cubit.dart';
import '../cubit/tools_state.dart';
import '../widgets/process_preview_dialog.dart';
import '../widgets/recent_processed_file_card.dart';
import '../widgets/tool_action_card.dart';
import 'compress_image_page.dart';
import 'image_to_pdf_page.dart';
import 'resize_image_page.dart';

enum _ToolsViewMode { grid, list }

class ToolsHomePage extends StatefulWidget {
  const ToolsHomePage({super.key});

  @override
  State<ToolsHomePage> createState() => _ToolsHomePageState();
}

class _ToolsHomePageState extends State<ToolsHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  var _viewMode = _ToolsViewMode.grid;
  var _isSearchExpanded = false;
  var _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopHeader(
        title: 'Tools',
        titleWidget: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _isSearchExpanded
              ? _ToolsTopSearchField(
                  key: const ValueKey('tools-top-search'),
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _setSearchQuery,
                  onClose: _collapseSearch,
                )
              : const Text('Tools', key: ValueKey('tools-title')),
        ),
        titleSpacing: _isSearchExpanded ? AppSizes.md : null,
        automaticallyImplyLeading: false,
        secondaryActions: _isSearchExpanded
            ? []
            : [
                IconButton(
                  tooltip: 'Search tools',
                  onPressed: _expandSearch,
                  constraints: const BoxConstraints(
                    minWidth: AppSizes.minTouchTarget,
                    minHeight: AppSizes.minTouchTarget,
                  ),
                  icon: const Icon(Icons.search_rounded, size: 20),
                ),
                _ToolsViewModeButton(
                  viewMode: _viewMode,
                  onToggle: _toggleViewMode,
                ),
              ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: BlocConsumer<ToolsCubit, ToolsState>(
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
              final tools = _tools(context);
              final filteredTools = _filterTools(tools);
              final filteredRecentFiles = _filterRecentFiles(state.recentFiles);
              return ListView(
                children: [
                  if (filteredTools.isEmpty)
                    const EmptyStateCard(
                      icon: Icons.search_off_rounded,
                      title: 'No tools found',
                      message: 'Try a different search term.',
                    )
                  else
                    _ToolsActionCollection(
                      tools: filteredTools,
                      viewMode: _viewMode,
                    ),
                  if (state.isLoading ||
                      filteredRecentFiles.isNotEmpty ||
                      _searchQuery.trim().isNotEmpty)
                    const SizedBox(height: AppSizes.lg),
                  if (state.isLoading ||
                      filteredRecentFiles.isNotEmpty ||
                      _searchQuery.trim().isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context.read<ToolsCubit>().refresh(),
                          child: const Text('Refresh activity'),
                        ),
                      ],
                    ),
                  if (state.isLoading ||
                      filteredRecentFiles.isNotEmpty ||
                      _searchQuery.trim().isNotEmpty)
                    const SizedBox(height: AppSizes.sm),
                  if (state.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (filteredRecentFiles.isEmpty)
                    EmptyStateCard(
                      icon: Icons.history_rounded,
                      title: _searchQuery.trim().isEmpty
                          ? 'No tool activity yet'
                          : 'No activity found',
                      message: _searchQuery.trim().isEmpty
                          ? 'Use a tool above to create a resized image, compressed image, or PDF.'
                          : 'Try a different search term.',
                    )
                  else
                    ...filteredRecentFiles.map(
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
        ),
      ),
    );
  }

  void _expandSearch() {
    _searchController.text = _searchQuery;
    setState(() {
      _isSearchExpanded = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _collapseSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _searchQuery = '';
      _isSearchExpanded = false;
    });
  }

  void _setSearchQuery(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _toggleViewMode() {
    setState(() {
      _viewMode = _viewMode == _ToolsViewMode.list
          ? _ToolsViewMode.grid
          : _ToolsViewMode.list;
    });
  }

  List<_ToolAction> _filterTools(List<_ToolAction> tools) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return tools;
    return tools
        .where(
          (tool) =>
              tool.title.toLowerCase().contains(query) ||
              tool.subtitle.toLowerCase().contains(query) ||
              tool.label.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  List<ProcessedFile> _filterRecentFiles(List<ProcessedFile> files) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return files;
    return files
        .where((file) {
          final title = file.metadata['title'] ?? '';
          return title.toLowerCase().contains(query) ||
              file.type.label.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  List<_ToolAction> _tools(BuildContext context) {
    return [
      _ToolAction(
        title: 'Resize Image',
        subtitle: 'Photos, signatures, target sizes',
        label: 'Image',
        icon: Icons.photo_size_select_actual_rounded,
        iconColor: AppColors.primary,
        iconBgColor: AppColors.infoContainer,
        labelColor: AppColors.primary,
        labelBgColor: AppColors.infoContainer,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<ToolsCubit>()),
                BlocProvider.value(value: context.read<ResizeImageCubit>()),
              ],
              child: const ResizeImagePage(),
            ),
          ),
        ),
      ),
      _ToolAction(
        title: 'Compress Image',
        subtitle: 'Reduce upload size cleanly',
        label: 'Image',
        icon: Icons.compress_rounded,
        iconColor: AppColors.warning,
        iconBgColor: AppColors.warningContainer,
        labelColor: AppColors.warning,
        labelBgColor: AppColors.warningContainer,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<ToolsCubit>()),
                BlocProvider.value(value: context.read<CompressImageCubit>()),
              ],
              child: const CompressImagePage(),
            ),
          ),
        ),
      ),
      _ToolAction(
        title: 'Image to PDF',
        subtitle: 'Combine pages into one file',
        label: 'PDF',
        icon: Icons.picture_as_pdf_rounded,
        iconColor: AppColors.accent,
        iconBgColor: AppColors.muted,
        labelColor: AppColors.accent,
        labelBgColor: AppColors.muted,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<ToolsCubit>()),
                BlocProvider.value(value: context.read<ImageToPdfCubit>()),
              ],
              child: const ImageToPdfPage(),
            ),
          ),
        ),
      ),
    ];
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

class _ToolAction {
  const _ToolAction({
    required this.title,
    required this.subtitle,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.labelColor,
    required this.labelBgColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color labelColor;
  final Color labelBgColor;
  final VoidCallback onTap;
}

class _ToolsActionCollection extends StatelessWidget {
  const _ToolsActionCollection({required this.tools, required this.viewMode});

  final List<_ToolAction> tools;
  final _ToolsViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    if (viewMode == _ToolsViewMode.list) {
      return Column(
        children: tools
            .map(
              (tool) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: _ToolActionListTile(tool: tool),
              ),
            )
            .toList(growable: false),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 420;
        final columnCount = isNarrow ? 1 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tools.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            mainAxisSpacing: AppSizes.md,
            crossAxisSpacing: AppSizes.md,
            childAspectRatio: isNarrow ? 0.95 : 0.94,
          ),
          itemBuilder: (context, index) {
            final tool = tools[index];
            return ToolActionCard(
              title: tool.title,
              subtitle: tool.subtitle,
              label: tool.label,
              icon: tool.icon,
              iconColor: tool.iconColor,
              iconBgColor: tool.iconBgColor,
              labelColor: tool.labelColor,
              labelBgColor: tool.labelBgColor,
              onTap: tool.onTap,
            );
          },
        );
      },
    );
  }
}

class _ToolActionListTile extends StatelessWidget {
  const _ToolActionListTile({required this.tool});

  final _ToolAction tool;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelText = tool.label;
    return Semantics(
      button: true,
      label: '${tool.title}. ${tool.subtitle}. Open.',
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0.2,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.65),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: tool.onTap,
          child: SizedBox(
            width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSizes.minTouchTarget - 8,
                        height: AppSizes.minTouchTarget - 8,
                        decoration: BoxDecoration(
                          color: tool.iconBgColor.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                        child: Icon(
                          tool.icon,
                          color: tool.iconColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tool.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                tool.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  height: 1.32,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (labelText.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: tool.labelBgColor.withValues(alpha: 0.32),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: tool.labelColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          labelText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: tool.labelColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSizes.xs),
                      Text(
                        'Open tool',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Divider(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.35,
                    ),
                    height: 1,
                    thickness: 0.6,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Open this workflow for quick configuration.',
                    maxLines: 2,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolsViewModeButton extends StatelessWidget {
  const _ToolsViewModeButton({required this.viewMode, required this.onToggle});

  final _ToolsViewMode viewMode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isGrid = viewMode == _ToolsViewMode.grid;
    return Tooltip(
      message: isGrid ? 'Switch to list view' : 'Switch to grid view',
      child: Semantics(
        button: true,
        label: isGrid ? 'Switch to list view' : 'Switch to grid view',
        child: IconButton(
          constraints: const BoxConstraints(
            minWidth: AppSizes.minTouchTarget,
            minHeight: AppSizes.minTouchTarget,
          ),
          onPressed: onToggle,
          icon: Icon(
            isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
          ),
        ),
      ),
    );
  }
}

class _ToolsTopSearchField extends StatelessWidget {
  const _ToolsTopSearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClose,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.minTouchTarget,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search tools',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              tooltip: 'Close search',
              onPressed: onClose,
              constraints: const BoxConstraints(
                minWidth: AppSizes.minTouchTarget,
                minHeight: AppSizes.minTouchTarget,
              ),
              icon: const Icon(Icons.close_rounded),
            ),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
        ),
      ),
    );
  }
}
