import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/enterprise_top_bar.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../home/presentation/cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _infoRoute = '/my-info';
  static const _documentsRoute = '/documents';
  static const _toolsRoute = '/tools';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EnterpriseTopBar(
        title: 'Home',
        subtitle: 'Info, docs, and quick tools',
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.md,
                    AppSizes.sm,
                    AppSizes.md,
                    112,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      _HomeHero(
                        state: state,
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: AppSizes.md),
                        _InlineNotice(message: state.errorMessage!),
                      ],
                      const SizedBox(height: AppSizes.lg),
                      const _HomeSectionTitle(
                        title: 'Saved essentials',
                        subtitle:
                            'Use Home to reach the two places you will come back to most.',
                      ),
                      const SizedBox(height: AppSizes.md),
                      _HomeDestinations(
                        state: state,
                        onOpenInfo: () => context.go(_infoRoute),
                        onOpenDocs: () => context.go(_documentsRoute),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      const _HomeSectionTitle(
                        title: 'Quick tools',
                        subtitle:
                            'Use Tools for one-time edits. Saved outputs and reusable files still live under Home.',
                      ),
                      const SizedBox(height: AppSizes.md),
                      _ToolsHubCard(onOpenTools: () => context.go(_toolsRoute)),
                      const SizedBox(height: AppSizes.sm),
                      _WorkflowShortcut(
                        title: 'Resize image',
                        description:
                            'Open Tools to set exact dimensions for photos and signatures.',
                        icon: Icons.photo_size_select_large_rounded,
                        onTap: () => context.go(_toolsRoute),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      _WorkflowShortcut(
                        title: 'Compress image',
                        description:
                            'Open Tools to reduce file size before upload or submission.',
                        icon: Icons.compress_rounded,
                        onTap: () => context.go(_toolsRoute),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      _WorkflowShortcut(
                        title: 'Image to PDF',
                        description:
                            'Open Tools to combine document photos into a single PDF.',
                        icon: Icons.picture_as_pdf_outlined,
                        onTap: () => context.go(_toolsRoute),
                      ),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.state,
  });

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      backgroundColor: theme.colorScheme.surface,
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.infoContainer,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Image.asset(
                  'assets/images/formsathi-logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      AppStrings.tagline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Keep your form details and submission files ready.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Open Info to save reusable details, jump into Docs for your saved files, or head to Tools for a quick one-time edit.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeDestinations extends StatelessWidget {
  const _HomeDestinations({
    required this.state,
    required this.onOpenInfo,
    required this.onOpenDocs,
  });

  final HomeState state;
  final VoidCallback onOpenInfo;
  final VoidCallback onOpenDocs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final infoCard = _PrimaryDestinationCard(
          title: 'Info',
          description:
              'Save personal details once so repeated forms are faster to fill.',
          supportingText: _infoSupportingText(state),
          summaryTone: state.isLoading
              ? _CardSummaryTone.info
              : state.hasUserInfo
              ? _CardSummaryTone.success
              : _CardSummaryTone.info,
          icon: Icons.badge_outlined,
          tintColor: AppColors.primary,
          onTap: onOpenInfo,
          actionLabel: 'Open Info',
        );
        final docsCard = _PrimaryDestinationCard(
          title: 'Docs',
          description:
              'Keep passport photos, signatures, IDs, and PDFs ready in one place.',
          supportingText: _docsSupportingText(state),
          summaryTone: state.isLoading
              ? _CardSummaryTone.info
              : state.documents.isEmpty
              ? _CardSummaryTone.info
              : _CardSummaryTone.success,
          icon: Icons.folder_open_outlined,
          tintColor: AppColors.accent,
          onTap: onOpenDocs,
          actionLabel: 'Open Docs',
        );

        if (constraints.maxWidth >= 720) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: infoCard),
              const SizedBox(width: AppSizes.md),
              Expanded(child: docsCard),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            infoCard,
            const SizedBox(height: AppSizes.md),
            docsCard,
          ],
        );
      },
    );
  }

  String _infoSupportingText(HomeState state) {
    if (state.isLoading) {
      return 'Checking if you already have reusable details saved offline.';
    }
    if (!state.hasUserInfo) {
      return 'Add your name, contact, IDs, and education details once.';
    }

    final name = state.userInfo.fullName.trim();
    final count = state.completedInfoFieldCount;
    if (name.isNotEmpty) {
      return '$count details saved for $name.';
    }
    return '$count details saved and ready to reuse.';
  }

  String _docsSupportingText(HomeState state) {
    if (state.isLoading) {
      return 'Checking your saved files and reusable document library.';
    }
    if (state.documents.isEmpty) {
      return 'Store your most-used submission files here for later exports.';
    }

    final latestTitle = state.latestDocument?.title ?? 'your latest file';
    return 'Latest saved file: $latestTitle.';
  }
}

class _PrimaryDestinationCard extends StatelessWidget {
  const _PrimaryDestinationCard({
    required this.title,
    required this.description,
    required this.supportingText,
    required this.summaryTone,
    required this.icon,
    required this.tintColor,
    required this.onTap,
    required this.actionLabel,
  });

  final String title;
  final String description;
  final String supportingText;
  final _CardSummaryTone summaryTone;
  final IconData icon;
  final Color tintColor;
  final VoidCallback onTap;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      backgroundColor: theme.colorScheme.surface,
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: tintColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: tintColor.withValues(alpha: 0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: tintColor.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: tintColor, size: 36),
              ),
              const SizedBox(width: AppSizes.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xs),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.3,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.82,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.18),
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardSummaryIcon(tone: summaryTone),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSizes.sm),
                  child: Text(
                    supportingText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      height: 1.15,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          FilledButton.tonalIcon(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
              padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
              backgroundColor: tintColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              textStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            iconAlignment: IconAlignment.end,
            label: Text(actionLabel),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}

enum _CardSummaryTone { success, info }

class _CardSummaryIcon extends StatelessWidget {
  const _CardSummaryIcon({required this.tone});

  final _CardSummaryTone tone;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground, IconData icon) = switch (tone) {
      _CardSummaryTone.success => (
        AppColors.success.withValues(alpha: 0.12),
        AppColors.success,
        Icons.check_rounded,
      ),
      _CardSummaryTone.info => (
        AppColors.infoContainer,
        AppColors.primary,
        Icons.info_outline_rounded,
      ),
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: foreground, size: 24),
    );
  }
}

class _ToolsHubCard extends StatelessWidget {
  const _ToolsHubCard({required this.onOpenTools});

  final VoidCallback onOpenTools;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.minTouchTarget,
            height: AppSizes.minTouchTarget,
            decoration: BoxDecoration(
              color: AppColors.infoContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tools is for quick processing',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Resize images, compress files, or create PDFs when you need a one-off result fast.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                FilledButton.tonalIcon(
                  onPressed: onOpenTools,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Open Tools'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkflowShortcut extends StatelessWidget {
  const _WorkflowShortcut({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSizes.cardRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              Container(
                width: AppSizes.minTouchTarget,
                height: AppSizes.minTouchTarget,
                decoration: BoxDecoration(
                  color: AppColors.infoContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Open',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSizes.xs),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      backgroundColor: AppColors.warningContainer,
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warning),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSectionTitle extends StatelessWidget {
  const _HomeSectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
