import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';
import '../services/user_service.dart';

/// User detail screen
class UserDetailScreen extends StatefulWidget {
  /// Creates a user detail screen
  const UserDetailScreen({
    required this.userId,
    super.key,
  });

  /// User ID
  final String userId;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userService = ServiceLocator.instance.get<UserService>();
      final user = await userService.getUserById(widget.userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load user details';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit user screen
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_errorMessage != null) {
      return ErrorView(
        message: _errorMessage!,
        onRetry: _loadUser,
      );
    }

    if (_user == null) {
      return const EmptyState(
        message: 'User not found',
        icon: Icons.person_outline,
      );
    }

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // User avatar
          CircleAvatar(
            radius: 50,
            child: Text(
              (_user!['name'] as String? ?? 'U')[0].toUpperCase(),
              style: theme.textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 24),

          // User info card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Name', _user!['name'] as String? ?? 'N/A'),
                const SizedBox(height: 12),
                _buildInfoRow('Email', _user!['email'] as String? ?? 'N/A'),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Tenant ID',
                  _user!['tenant_id'] as String? ?? 'N/A',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Actions
          AppButton(
            text: 'Delete User',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete User'),
                  content: const Text(
                    'Are you sure you want to delete this user?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && mounted) {
                // Delete user logic
                Navigator.of(context).pop();
              }
            },
            variant: ButtonVariant.outline,
            icon: Icons.delete_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
