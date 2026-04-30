import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_scaffold.dart';

class ToolDetailStatusTone {
  const ToolDetailStatusTone._();

  static const neutral = 0;
  static const success = 1;
  static const warning = 2;
  static const error = 3;
  static const info = 4;
}

class ToolDetailStatusItem {
  const ToolDetailStatusItem({
    required this.label,
    required this.value,
    required this.icon,
    this.tone = ToolDetailStatusTone.neutral,
  });

  final String label;
  final String value;
  final IconData icon;
  final int tone;
}

class ToolActionButtonData {
  const ToolActionButtonData({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.loading = false,
    this.isPrimary = false,
    this.enabled = true,
    this.semanticLabel,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool loading;
  final bool isPrimary;
  final bool enabled;
  final String? semanticLabel;
}

class ToolRelatedToolItem {
  const ToolRelatedToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.iconColor = AppColors.primary,
    this.iconBackground = AppColors.infoContainer,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;
}

class ToolDetailsPageTemplate extends StatelessWidget {
  const ToolDetailsPageTemplate({
    required this.toolTitle,
    required this.toolIcon,
    required this.toolIconColor,
    required this.toolIconBackground,
    required this.summary,
    required this.usage,
    required this.statusItems,
    required this.contentCards,
    required this.primaryAction,
    super.key,
    this.secondaryAction,
    this.resultCard,
    this.relatedTools = const <ToolRelatedToolItem>[],
    this.headerActions = const <Widget>[],
    this.loadingHint,
    this.inlineError,
    this.successHint,
  });

  final String toolTitle;
  final IconData toolIcon;
  final Color toolIconColor;
  final Color toolIconBackground;
  final String summary;
  final String usage;
  final List<ToolDetailStatusItem> statusItems;
  final List<Widget> contentCards;
  final ToolActionButtonData primaryAction;
  final ToolActionButtonData? secondaryAction;
  final Widget? resultCard;
  final List<ToolRelatedToolItem> relatedTools;
  final List<Widget> headerActions;
  final String? loadingHint;
  final String? inlineError;
  final String? successHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = <Widget>[];

    content
      ..add(
        ToolDetailPanel(
          title: 'Tool details',
          subtitle: usage,
          icon: toolIcon,
          iconColor: toolIconColor,
          iconBackground: toolIconBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                summary,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              ToolStatusStrip(items: statusItems),
            ],
          ),
        ),
      )
      ..addAll(contentCards);

    if (inlineError != null) {
      content.add(
        const SizedBox(height: AppSizes.md),
      );
      content.add(
        ToolFeedbackBanner(
          message: inlineError!,
          tone: ToolDetailStatusTone.error,
          icon: Icons.error_outline_rounded,
        ),
      );
    }

    if (loadingHint != null) {
      content.add(const SizedBox(height: AppSizes.md));
      content.add(
        ToolFeedbackBanner(
          message: loadingHint!,
          tone: ToolDetailStatusTone.info,
          icon: Icons.hourglass_bottom_rounded,
        ),
      );
    }

    if (successHint != null) {
      content.add(const SizedBox(height: AppSizes.md));
      content.add(
        ToolFeedbackBanner(
          message: successHint!,
          tone: ToolDetailStatusTone.success,
          icon: Icons.check_circle_outline_rounded,
        ),
      );
    }

    content
      ..add(const SizedBox(height: AppSizes.lg))
      ..add(
        ToolActionPanel(
          primaryAction: primaryAction,
          secondaryAction: secondaryAction,
        ),
      );

    if (resultCard != null) {
      content
            ..add(const SizedBox(height: AppSizes.lg))
        ..add(resultCard!);
    }

    if (relatedTools.isNotEmpty) {
      content
        ..add(const SizedBox(height: AppSizes.lg))
        ..add(
          ToolRelatedToolsPanel(
            tools: relatedTools,
            title: 'Related tools',
            subtitle: 'Use these next to complete related workflows quickly.',
          ),
        );
    }

    return AppScaffold(
      title: toolTitle,
      actions: headerActions,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ...content,
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }
}

class ToolDetailPanel extends StatelessWidget {
  const ToolDetailPanel({
    required this.title,
    required this.child,
    super.key,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconBackground,
    this.leadingAction,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackground;
  final Widget? leadingAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.2,
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.cardRadius,
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.38),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null)
                  Container(
                    width: AppSizes.minTouchTarget,
                    height: AppSizes.minTouchTarget,
                    decoration: BoxDecoration(
                      color: (iconBackground ?? AppColors.infoContainer)
                          .withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (iconColor ?? AppColors.primary).withValues(
                          alpha: 0.24,
                        ),
                      ),
                    ),
                    child: Icon(icon, color: iconColor, size: 23),
                  ),
                if (icon != null) const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (leadingAction != null) leadingAction!,
              ],
            ),
            const SizedBox(height: AppSizes.md),
            child,
          ],
        ),
      ),
    );
  }
}

class ToolStatusStrip extends StatelessWidget {
  const ToolStatusStrip({
    required this.items,
    super.key,
  });

  final List<ToolDetailStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: items
          .map(
            (status) => ToolStatusBadge(
              label: status.label,
              value: status.value,
              icon: status.icon,
              tone: status.tone,
            ),
          )
          .toList(growable: false),
    );
  }
}

class ToolStatusBadge extends StatelessWidget {
  const ToolStatusBadge({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.tone = ToolDetailStatusTone.neutral,
  });

  final String label;
  final String value;
  final IconData icon;
  final int tone;

  Color _toneColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (tone) {
      case ToolDetailStatusTone.success:
        return AppColors.success;
      case ToolDetailStatusTone.warning:
        return AppColors.warning;
      case ToolDetailStatusTone.error:
        return theme.colorScheme.error;
      case ToolDetailStatusTone.info:
        return AppColors.infoContainer;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final toneColor = _toneColor(context);
    final labelStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: toneColor,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      height: 1.2,
    );
    return Semantics(
      label: '$label: $value',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: toneColor.withValues(alpha: 0.12),
          border: Border.all(color: toneColor.withValues(alpha: 0.33), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: toneColor),
            const SizedBox(width: 6),
            Text(label, style: labelStyle),
            const SizedBox(width: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToolFeedbackBanner extends StatelessWidget {
  const ToolFeedbackBanner({
    required this.message,
    required this.tone,
    required this.icon,
    super.key,
  });

  final String message;
  final int tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color background;
    Color border;
    Color foreground;

    switch (tone) {
      case ToolDetailStatusTone.success:
        background = AppColors.successContainer;
        border = AppColors.success.withValues(alpha: 0.4);
        foreground = AppColors.success;
        break;
      case ToolDetailStatusTone.warning:
        background = AppColors.warningContainer;
        border = AppColors.warning.withValues(alpha: 0.4);
        foreground = AppColors.warning;
        break;
      case ToolDetailStatusTone.error:
        background = AppColors.destructiveContainer;
        border = AppColors.destructive.withValues(alpha: 0.45);
        foreground = AppColors.destructive;
        break;
      case ToolDetailStatusTone.info:
      default:
        background = AppColors.infoContainer;
        border = AppColors.primary.withValues(alpha: 0.4);
        foreground = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: background,
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToolActionPanel extends StatelessWidget {
  const ToolActionPanel({
    required this.primaryAction,
    super.key,
    this.secondaryAction,
  });

  final ToolActionButtonData primaryAction;
  final ToolActionButtonData? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ToolActionButton(config: primaryAction, isPrimary: true),
        ),
        if (secondaryAction != null) ...[
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: _ToolActionButton(config: secondaryAction!, isPrimary: false),
          ),
        ],
      ],
    );
  }
}

class _ToolActionButton extends StatelessWidget {
  const _ToolActionButton({required this.config, required this.isPrimary});

  final ToolActionButtonData config;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final enabled = config.enabled && !config.loading && config.onPressed != null;

    final child = isPrimary
        ? FilledButton.icon(
            onPressed: enabled ? config.onPressed : null,
            icon: config.loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(config.icon, size: 18),
            label: Text(config.label),
          )
        : OutlinedButton.icon(
            onPressed: enabled ? config.onPressed : null,
            icon: config.loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(config.icon, size: 18),
            label: Text(config.label),
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: config.semanticLabel ?? config.label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTouchTarget),
        child: child,
      ),
    );
  }
}

class ToolRelatedToolsPanel extends StatelessWidget {
  const ToolRelatedToolsPanel({
    required this.tools,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final List<ToolRelatedToolItem> tools;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.2,
      shape: RoundedRectangleBorder(
        borderRadius: AppSizes.cardRadius,
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            for (final tool in tools) ...[
              ListTile(
                dense: true,
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tool.iconBackground.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tool.icon, size: 17, color: tool.iconColor),
                ),
                title: Text(
                  tool.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(tool.subtitle),
                trailing: tool.onTap == null ? null : const Icon(Icons.chevron_right_rounded),
                onTap: tool.onTap,
              ),
              if (tool != tools.last) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}
