import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class AppNavigationShell extends StatefulWidget {
  const AppNavigationShell({
    required this.child,
    required this.currentLocation,
    super.key,
  });

  final Widget child;
  final String currentLocation;

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryAnimationController;

  @override
  void initState() {
    super.initState();
    _entryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 380),
      vsync: this,
    );
    _entryAnimationController.forward();
  }

  @override
  void dispose() {
    _entryAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(widget.currentLocation);

    return Scaffold(
      body: widget.child,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.md,
            right: AppSizes.md,
            bottom: AppSizes.lg,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _entryAnimationController,
              curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _entryAnimationController,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: _FloatingBottomNavBar(
                selectedIndex: selectedIndex,
                onDestinationTapped: _onDestinationTapped,
                items: AppRouterTabs.items,
                activeColor: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onDestinationTapped(int index) {
    final location = AppRouterTabs.locations[index];
    if (_selectedIndex(widget.currentLocation) != index) {
      context.go(location);
    }
  }

  int _selectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/documents')) return 1;
    if (location.startsWith('/tools')) return 2;
    if (location.startsWith('/settings')) return 3;
    if (location.startsWith('/my-info')) return 4;
    return 0;
  }
}

class _FloatingBottomNavBar extends StatelessWidget {
  const _FloatingBottomNavBar({
    required this.selectedIndex,
    required this.onDestinationTapped,
    required this.items,
    required this.activeColor,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationTapped;
  final List<_BottomNavigationItem> items;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColorWithShadow = activeColor.withValues(alpha: 0.15);

    return Material(
      color: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(999)),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(999)),
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 22,
                  spreadRadius: 0.2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 62,
                  maxHeight: 62,
                ),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = selectedIndex == index;

                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: isSelected
                              ? activeColorWithShadow
                              : Colors.transparent,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                          child: InkWell(
                            onTap: () => onDestinationTapped(index),
                            borderRadius: BorderRadius.circular(999),
                            child: Semantics(
                              button: true,
                              selected: isSelected,
                              label: item.label,
                              hint: isSelected
                                  ? '${item.label} tab selected'
                                  : 'Navigate to ${item.label}',
                              child: Tooltip(
                                message: item.label,
                                child: SizedBox(
                                  height: 46,
                                  child: Center(
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale: Tween<double>(
                                              begin: 0.9,
                                              end: 1.0,
                                            ).animate(animation),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        isSelected
                                            ? item.selectedIcon
                                            : item.icon,
                                        key: ValueKey<bool>(isSelected),
                                        size: 28,
                                        color: isSelected
                                            ? activeColor
                                            : theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationItem {
  const _BottomNavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class AppRouterTabs {
  const AppRouterTabs._();

  static const locations = [
    '/home',
    '/documents',
    '/tools',
    '/settings',
    '/my-info',
  ];

  static const items = [
    _BottomNavigationItem(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    _BottomNavigationItem(
      label: 'Search',
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
    ),
    _BottomNavigationItem(
      label: 'Gallery',
      icon: Icons.collections_outlined,
      selectedIcon: Icons.collections,
    ),
    _BottomNavigationItem(
      label: 'Cart',
      icon: Icons.shopping_cart_outlined,
      selectedIcon: Icons.shopping_cart,
    ),
    _BottomNavigationItem(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];
}
