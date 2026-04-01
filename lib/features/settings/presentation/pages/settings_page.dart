import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/section_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      title: 'About',
      body: ListView(
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  AppStrings.tagline,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),
          const SectionCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.verified_user_outlined),
              title: Text('Offline first'),
              subtitle: Text(AppStrings.privacyMessage),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          const SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Future scope',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: AppSizes.sm),
                Text('Google Drive backup'),
                Text('Premium version'),
                Text('Reminders'),
                Text('Checklist'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
