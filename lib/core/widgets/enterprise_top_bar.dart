import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import '../theme/enterprise_header_tokens.dart';

class EnterpriseTopBar extends StatelessWidget implements PreferredSizeWidget {
  const EnterpriseTopBar({
    required this.title,
    super.key,
    this.subtitle,
    this.titleWidget,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.compact = true,
    this.showBottomDivider = false,
  });

  final String title;
  final String? subtitle;
  final Widget? titleWidget;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final bool compact;
  final bool showBottomDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      toolbarHeight: compact
          ? EnterpriseHeaderTokens.compactHeight
          : EnterpriseHeaderTokens.expandedHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: false,
      leading: leading,
      leadingWidth: EnterpriseHeaderTokens.leadingWidth,
      titleSpacing: EnterpriseHeaderTokens.titleSpacing,
      title: SizedBox(
        height: AppSizes.minTouchTarget,
        child: Align(alignment: Alignment.centerLeft, child: _buildTitle(context)),
      ),
      actions: _buildActions(),
      shape: showBottomDivider
          ? Border(bottom: BorderSide(color: theme.colorScheme.outline, width: 0.8))
          : null,
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (titleWidget != null) {
      return titleWidget!;
    }

    final theme = Theme.of(context);
    final contentColor = theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface;

    final titleText = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: EnterpriseHeaderTokens.titleTextStyle(
        theme.textTheme,
        contentColor,
      ),
    );

    if (subtitle == null) return titleText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleText,
        const SizedBox(height: EnterpriseHeaderTokens.titleToSubtitleGap),
        Text(
          subtitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: EnterpriseHeaderTokens.subtitleTextStyle(
            theme.textTheme,
            contentColor.withValues(alpha: 0.68),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions() {
    if (actions == null || actions!.isEmpty) return const [];

    return actions!
        .map(
          (action) => Padding(
            padding: const EdgeInsets.only(left: EnterpriseHeaderTokens.actionPadding),
            child: action,
          ),
        )
        .toList(growable: false);
  }

  @override
  Size get preferredSize => Size.fromHeight(
    compact ? EnterpriseHeaderTokens.compactHeight : EnterpriseHeaderTokens.expandedHeight,
  );
}
