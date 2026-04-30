import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_sizes.dart';

class AppNavigationShell extends StatelessWidget {
  const AppNavigationShell({
    required this.child,
    required this.currentLocation,
    super.key,
  });

  final Widget child;
  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        height: AppSizes.bottomNavHeight,
        selectedIndex: _selectedIndex(currentLocation),
        onDestinationSelected: (index) {
          context.go(AppRouterTabs.locations[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'Info',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_copy_outlined),
            selectedIcon: Icon(Icons.folder_copy),
            label: 'Docs',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_rounded),
            selectedIcon: Icon(Icons.tune),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(String location) {
    if (location.startsWith('/documents')) return 1;
    if (location.startsWith('/tools')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }
}

class AppRouterTabs {
  const AppRouterTabs._();

  static const locations = ['/my-info', '/documents', '/tools', '/settings'];
}
