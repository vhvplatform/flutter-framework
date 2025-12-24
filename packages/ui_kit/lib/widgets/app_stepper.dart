import 'package:flutter/material.dart';

/// A horizontal stepper widget for multi-step processes.
///
/// Example:
/// ```dart
/// AppStepper(
///   steps: ['Account', 'Profile', 'Confirm'],
///   currentStep: _currentStep,
///   onStepTap: (index) => setState(() => _currentStep = index),
/// )
/// ```
class AppStepper extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;

  const AppStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTap,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ?? theme.disabledColor;
    final effectiveCompletedColor = completedColor ?? Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: List.generate(
          steps.length * 2 - 1,
          (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              final isActive = stepIndex == currentStep;
              final isCompleted = stepIndex < currentStep;

              return Expanded(
                child: InkWell(
                  onTap: onStepTap != null ? () => onStepTap!(stepIndex) : null,
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? effectiveCompletedColor
                              : isActive
                                  ? effectiveActiveColor
                                  : effectiveInactiveColor.withOpacity(0.2),
                          border: Border.all(
                            color: isCompleted
                                ? effectiveCompletedColor
                                : isActive
                                    ? effectiveActiveColor
                                    : effectiveInactiveColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : Text(
                                  '${stepIndex + 1}',
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : effectiveInactiveColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        steps[stepIndex],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isActive || isCompleted
                              ? theme.textTheme.bodySmall?.color
                              : effectiveInactiveColor,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;

              return Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 40),
                  color: isCompleted
                      ? effectiveCompletedColor
                      : effectiveInactiveColor.withOpacity(0.3),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
