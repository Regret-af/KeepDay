import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton.primary({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  }) : _variant = _AppButtonVariant.primary;

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  }) : _variant = _AppButtonVariant.secondary;

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final _AppButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label),
            ],
          );

    return switch (_variant) {
      _AppButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        child: child,
      ),
      _AppButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
    };
  }
}

enum _AppButtonVariant { primary, secondary }
