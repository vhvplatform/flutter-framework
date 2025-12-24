import 'package:flutter/material.dart';

/// Quick actions for faster development
/// Provides shortcuts to common development tasks
class QuickActions {
  static final List<QuickAction> _actions = [];

  /// Register a quick action
  static void register(QuickAction action) {
    _actions.add(action);
  }

  /// Get all registered actions
  static List<QuickAction> get actions => List.unmodifiable(_actions);

  /// Clear all actions
  static void clear() {
    _actions.clear();
  }

  /// Show quick actions dialog
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => QuickActionsSheet(actions: _actions),
    );
  }
}

/// Quick action definition
class QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });
}

/// Quick actions bottom sheet
class QuickActionsSheet extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsSheet({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: actions.map((action) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  action.onTap();
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: action.color?.withOpacity(0.1) ?? Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        action.icon,
                        size: 20,
                        color: action.color ?? Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        action.label,
                        style: TextStyle(
                          color: action.color ?? Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
