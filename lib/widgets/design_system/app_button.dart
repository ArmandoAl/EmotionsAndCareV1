import 'package:flutter/material.dart';

import '../../config/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, destructive, text }

/// Botón estándar de la app. Sustituye los `ElevatedButton`/`TextButton`
/// con `ButtonStyle` inline repetidos en ~22 pantallas, con estado de
/// carga y deshabilitado integrados en vez de que cada pantalla intercambie
/// manualmente el `child` por un `CircularProgressIndicator`.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool expand;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expand = false,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = false,
  }) : variant = AppButtonVariant.destructive;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = false,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || isLoading;
    final VoidCallback? effectiveOnPressed = disabled ? null : onPressed;

    final Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor(context)),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label),
            ],
          );

    final Widget button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: effectiveOnPressed, child: child),
      AppButtonVariant.secondary => OutlinedButton(onPressed: effectiveOnPressed, child: child),
      AppButtonVariant.destructive => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.text => TextButton(onPressed: effectiveOnPressed, child: child),
    };

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  Color _foregroundColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (variant) {
      AppButtonVariant.primary => scheme.onPrimary,
      AppButtonVariant.destructive => scheme.onError,
      AppButtonVariant.secondary || AppButtonVariant.text => scheme.primary,
    };
  }
}
