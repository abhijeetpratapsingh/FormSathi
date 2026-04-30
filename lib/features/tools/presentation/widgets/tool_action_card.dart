import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class ToolActionCard extends StatelessWidget {
  const ToolActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
    this.label,
    this.iconColor,
    this.iconBgColor,
    this.labelColor,
    this.labelBgColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? label;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? labelColor;
  final Color? labelBgColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeLabel = (label ?? '').trim();
    final hasLabel = safeLabel.isNotEmpty;

    return Semantics(
      button: true,
      label: '$title. $subtitle. Open.',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0.35,
        shadowColor: theme.colorScheme.outline.withValues(alpha: 0.22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.16),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 190;
              final titleMaxLines = isCompact ? 1 : 2;
              final subtitleMaxLines = 1;
              final iconSize = isCompact ? 18.0 : 20.0;
              final iconContainer = isCompact ? 36.0 : 40.0;
              final verticalSpaceSmall = isCompact ? 2.0 : 4.0;
              final titleStyle = theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
                height: isCompact ? 1.15 : 1.2,
              );
              final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: isCompact ? 1.15 : 1.25,
              );

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: iconContainer,
                          height: iconContainer,
                          decoration: BoxDecoration(
                            color: iconBgColor ??
                                AppColors.infoContainer.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (iconColor ?? AppColors.primary).withValues(
                                alpha: 0.24,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: iconColor ?? AppColors.primary,
                            size: iconSize,
                          ),
                        ),
                    if (hasLabel)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: labelBgColor ??
                                  AppColors.successContainer.withValues(
                                    alpha: 0.85,
                                  ),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: (labelColor ?? AppColors.success)
                                    .withValues(alpha: 0.22),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              safeLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: labelColor ?? AppColors.success,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: verticalSpaceSmall),
                    Text(
                      title,
                      maxLines: titleMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle,
                    ),
                    SizedBox(height: verticalSpaceSmall),
                    Text(
                      subtitle,
                      maxLines: subtitleMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: subtitleStyle,
                        ),
                    SizedBox(height: isCompact ? 2 : 3),
                    Text(
                      'Open tool',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                        height: 1.0,
                      ),
                    ),
                    if (isCompact) ...[
                      const SizedBox(height: 1),
                      const Divider(height: 1, thickness: 0.6),
                      const SizedBox(height: 1),
                    ] else
                      const SizedBox(height: AppSizes.xs),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
