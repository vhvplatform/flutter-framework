import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';
import '../widgets/stats_widget.dart';

/// Dashboard screen
class DashboardScreen extends StatelessWidget {
  /// Creates a dashboard screen
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authManager = ServiceLocator.instance.get<AuthManager>();
    final user = authManager.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authManager.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Welcome back, ${user?.name ?? "User"}!',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tenant: ${user?.tenantId ?? "N/A"}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),

            // Stats grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: const [
                StatsWidget(
                  title: 'Total Users',
                  value: '1,234',
                  icon: Icons.people_outline,
                  trend: '+12.5%',
                ),
                StatsWidget(
                  title: 'Revenue',
                  value: '\$45.2K',
                  icon: Icons.attach_money,
                  trend: '+8.3%',
                ),
                StatsWidget(
                  title: 'Active Projects',
                  value: '23',
                  icon: Icons.folder_outlined,
                  trend: '+4',
                ),
                StatsWidget(
                  title: 'Tasks',
                  value: '156',
                  icon: Icons.task_outlined,
                  trend: '-3',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick actions
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_add_outlined),
                    title: const Text('Add User'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to add user screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.folder_outlined),
                    title: const Text('Create Project'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to create project screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to settings screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
