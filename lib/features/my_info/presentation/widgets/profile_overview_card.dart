import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/section_card.dart';

enum ProfileOverviewTone { success, warning, info }

class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({
    required this.profilePhotoPath,
    required this.displayName,
    required this.onTap,
    required this.onAvatarTap,
    this.title = 'Your Profile',
    this.supportingText,
    this.fallbackIdentityText = 'Add your name in Info',
    super.key,
  });

  final String profilePhotoPath;
  final String displayName;
  final VoidCallback onTap;
  final VoidCallback onAvatarTap;
  final String title;
  final String? supportingText;
  final String fallbackIdentityText;

  @override
  Widget build(BuildContext context) {
    final resolvedSupportingText =
        supportingText ??
        'Manage your saved identity details and profile photo from here.';

    return SectionCard(
      backgroundColor: AppColors.surface,
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: AppSizes.cardRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: _ProfileIdentityHeader(
            profilePhotoPath: profilePhotoPath,
            displayName: displayName,
            title: title,
            supportingText: resolvedSupportingText,
            fallbackIdentityText: fallbackIdentityText,
            onAvatarTap: onAvatarTap,
          ),
        ),
      ),
    );
  }
}

class ProfileOverviewCard extends StatelessWidget {
  const ProfileOverviewCard({
    required this.completion,
    required this.segments,
    required this.nextStep,
    required this.autosaveLabel,
    required this.autosaveIcon,
    required this.autosaveTone,
    required this.displayName,
    required this.onTap,
    required this.onRetrySave,
    required this.onCopyAll,
    super.key,
  });

  final double completion;
  final List<bool> segments;
  final String nextStep;
  final String autosaveLabel;
  final IconData autosaveIcon;
  final ProfileOverviewTone autosaveTone;
  final String displayName;
  final VoidCallback onTap;
  final VoidCallback? onRetrySave;
  final VoidCallback? onCopyAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (completion * 100).round();
    final hasRetry = onRetrySave != null;
    return SectionCard(
      backgroundColor: AppColors.surface,
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: AppSizes.cardRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoOverviewHeader(
                displayName: displayName,
                title: 'My Info',
                supportingText:
                    'Review, update, and reuse your saved details from one place.',
              ),
              const SizedBox(height: AppSizes.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: AppSizes.fieldRadius,
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.7),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Progress',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$percent%',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _SegmentedCompletionBar(segments: segments),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      nextStep,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCopyAll,
                      icon: const Icon(Icons.copy_all_rounded),
                      label: const Text('Copy All'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  _AutosaveIconButton(
                    icon: autosaveIcon,
                    label: autosaveLabel,
                    tone: autosaveTone,
                  ),
                  if (hasRetry) ...[
                    const SizedBox(width: AppSizes.sm),
                    FilledButton.tonalIcon(
                      onPressed: onRetrySave,
                      icon: const Icon(Icons.sync_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoOverviewHeader extends StatelessWidget {
  const _InfoOverviewHeader({
    required this.displayName,
    required this.title,
    required this.supportingText,
  });

  final String displayName;
  final String title;
  final String supportingText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmedName = displayName.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.18),
            ),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.badge_outlined,
            size: 30,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
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
                trimmedName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (trimmedName.isNotEmpty) const SizedBox(height: AppSizes.xs),
              Text(
                supportingText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileIdentityHeader extends StatelessWidget {
  const _ProfileIdentityHeader({
    required this.profilePhotoPath,
    required this.displayName,
    required this.title,
    required this.supportingText,
    required this.fallbackIdentityText,
    required this.onAvatarTap,
  });

  final String profilePhotoPath;
  final String displayName;
  final String title;
  final String supportingText;
  final String fallbackIdentityText;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmedName = displayName.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAvatar(
          photoPath: profilePhotoPath,
          displayName: displayName,
          onTap: onAvatarTap,
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
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
                trimmedName.isEmpty ? fallbackIdentityText : trimmedName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: trimmedName.isEmpty
                      ? theme.colorScheme.onSurfaceVariant
                      : null,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                supportingText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.photoPath,
    required this.displayName,
    required this.onTap,
    super.key,
  });

  final String photoPath;
  final String displayName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmedName = displayName.trim();
    final initial = trimmedName.isEmpty
        ? null
        : trimmedName.characters.first.toUpperCase();
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();
    return Semantics(
      button: true,
      label: hasPhoto ? 'Edit profile photo' : 'Add profile photo',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 64,
          width: 64,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: initial == null
                        ? AppColors.muted
                        : AppColors.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    image: hasPhoto
                        ? DecorationImage(
                            image: FileImage(File(photoPath)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: hasPhoto
                      ? null
                      : Text(
                          initial ?? 'I',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: initial == null
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentedCompletionBar extends StatelessWidget {
  const _SegmentedCompletionBar({required this.segments});

  final List<bool> segments;

  @override
  Widget build(BuildContext context) {
    final visibleSegments = segments.isEmpty ? const [false] : segments;
    return Row(
      children: [
        for (var index = 0; index < visibleSegments.length; index++) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 6,
              decoration: BoxDecoration(
                color: visibleSegments[index]
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.border.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          if (index != visibleSegments.length - 1)
            const SizedBox(width: AppSizes.xs),
        ],
      ],
    );
  }
}

class _AutosaveIconButton extends StatelessWidget {
  const _AutosaveIconButton({
    required this.icon,
    required this.label,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final ProfileOverviewTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = switch (tone) {
      ProfileOverviewTone.success => (
        foreground: AppColors.success,
        background: AppColors.success.withValues(alpha: 0.12),
      ),
      ProfileOverviewTone.warning => (
        foreground: AppColors.warning,
        background: AppColors.warning.withValues(alpha: 0.12),
      ),
      ProfileOverviewTone.info => (
        foreground: theme.colorScheme.primary,
        background: theme.colorScheme.primary.withValues(alpha: 0.12),
      ),
    };
    final isSaving = label == 'Saving...';

    return Tooltip(
      message: label,
      child: Semantics(
        label: 'Autosave status: $label',
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.foreground.withValues(alpha: 0.18),
            ),
          ),
          alignment: Alignment.center,
          child: isSaving
              ? SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colors.foreground,
                    ),
                  ),
                )
              : Icon(icon, size: 18, color: colors.foreground),
        ),
      ),
    );
  }
}
