import 'package:flutter/material.dart';

class EnterpriseHeaderTokens {
  const EnterpriseHeaderTokens._();

  static const double compactHeight = 52;
  static const double expandedHeight = 56;
  static const double leadingWidth = 44;
  static const double titleSpacing = 10;
  static const double actionPadding = 6;
  static const double actionSize = 36;
  static const double actionIconSize = 20;

  static const double iconToTextGap = 0;
  static const double titleToSubtitleGap = 3;

  static TextStyle titleTextStyle(TextTheme textTheme, Color color) {
    return textTheme.titleMedium!.copyWith(
      color: color,
      fontSize: 16,
      height: 1.2,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.2,
    );
  }

  static TextStyle subtitleTextStyle(TextTheme textTheme, Color color) {
    return textTheme.labelSmall!.copyWith(
      color: color,
      fontSize: 11,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    );
  }
}

class EnterpriseHeaderIcons {
  const EnterpriseHeaderIcons._();

  static const IconData primaryAction = Icons.more_horiz_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData notifications = Icons.notifications_none_rounded;
}
