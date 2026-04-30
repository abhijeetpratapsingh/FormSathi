import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

enum AppTopHeaderRightActionType { none, menu }

class AppTopHeaderMenuItem<T extends Object> {
  const AppTopHeaderMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.destructive = false,
    this.enabled = true,
    this.tooltip,
  });

  final T value;
  final String label;
  final IconData icon;
  final bool destructive;
  final bool enabled;
  final String? tooltip;
}

class AppTopHeader<T extends Object> extends StatelessWidget
    implements PreferredSizeWidget {
  const AppTopHeader({
    required this.title,
    super.key,
    this.titleWidget,
    this.rightActionType = AppTopHeaderRightActionType.none,
    this.menuItems = const [],
    this.onMenuAction,
    this.secondaryActions = const [],
    this.toolbarHeight = kToolbarHeight,
    this.titleSpacing,
    this.automaticallyImplyLeading = false,
    this.menuTooltip = 'More actions',
    this.centerTitle = false,
  });

  final String title;
  final Widget? titleWidget;
  final AppTopHeaderRightActionType rightActionType;
  final List<AppTopHeaderMenuItem<T>> menuItems;
  final ValueChanged<T>? onMenuAction;
  final List<Widget> secondaryActions;
  final double toolbarHeight;
  final double? titleSpacing;
  final bool automaticallyImplyLeading;
  final String menuTooltip;
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    assert(
      rightActionType != AppTopHeaderRightActionType.menu || menuItems.isNotEmpty,
      'menuItems is required when rightActionType is menu.',
    );
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      title:
          titleWidget ??
          Text(title, overflow: TextOverflow.ellipsis, maxLines: 1),
      actions: _buildActions(context),
      actionsPadding: const EdgeInsetsDirectional.only(end: AppSizes.xs),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final actionItems = List<Widget>.from(secondaryActions);

    if (rightActionType == AppTopHeaderRightActionType.menu) {
      actionItems.add(
        PopupMenuButton<T>(
          tooltip: menuTooltip,
          icon: Icon(
            Icons.more_vert_rounded,
            size: 20,
            color: theme.iconTheme.color?.withValues(alpha: 0.95),
          ),
          constraints: const BoxConstraints(
            minWidth: AppSizes.minTouchTarget,
            minHeight: AppSizes.minTouchTarget,
          ),
          onSelected: onMenuAction,
          itemBuilder: (context) => menuItems
              .map(
                (item) => PopupMenuItem<T>(
                  value: item.value,
                  enabled: item.enabled,
                  child: ListTile(
                    dense: true,
                    minLeadingWidth: 0,
                    leading: Icon(
                      item.icon,
                      size: 20,
                      color: item.destructive
                          ? theme.colorScheme.error
                          : theme.iconTheme.color,
                    ),
                    title: Text(
                      item.label,
                      style: item.destructive
                          ? TextStyle(color: theme.colorScheme.error)
                          : null,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    return actionItems;
  }
}
