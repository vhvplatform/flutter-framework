import 'package:flutter/material.dart';

/// Helper class for showing bottom sheets with consistent styling.
class BottomSheetHelper {
  /// Show a modal bottom sheet with a title and content.
  ///
  /// Example:
  /// ```dart
  /// await BottomSheetHelper.show(
  ///   context,
  ///   title: 'Select Option',
  ///   builder: (context) => ListView(...),
  /// );
  /// ```
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (title != null) ...[
              _BottomSheetHeader(title: title),
              const Divider(height: 1),
            ],
            Flexible(
              child: builder(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Show a bottom sheet with a list of options.
  ///
  /// Example:
  /// ```dart
  /// final result = await BottomSheetHelper.showOptions(
  ///   context,
  ///   title: 'Choose Action',
  ///   options: [
  ///     BottomSheetOption(label: 'Edit', icon: Icons.edit),
  ///     BottomSheetOption(label: 'Delete', icon: Icons.delete, isDestructive: true),
  ///   ],
  /// );
  /// ```
  static Future<T?> showOptions<T>({
    required BuildContext context,
    String? title,
    required List<BottomSheetOption<T>> options,
  }) {
    return show<T>(
      context: context,
      title: title,
      builder: (context) => ListView.separated(
        shrinkWrap: true,
        itemCount: options.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            leading: option.icon != null
                ? Icon(
                    option.icon,
                    color: option.isDestructive ? Colors.red : null,
                  )
                : null,
            title: Text(
              option.label,
              style: TextStyle(
                color: option.isDestructive ? Colors.red : null,
              ),
            ),
            onTap: () => Navigator.of(context).pop(option.value),
          );
        },
      ),
    );
  }
}

class _BottomSheetHeader extends StatelessWidget {
  final String title;

  const _BottomSheetHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// Option data class for bottom sheet options.
class BottomSheetOption<T> {
  final String label;
  final IconData? icon;
  final T? value;
  final bool isDestructive;

  const BottomSheetOption({
    required this.label,
    this.icon,
    this.value,
    this.isDestructive = false,
  });
}
