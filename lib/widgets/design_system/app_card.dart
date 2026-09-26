import 'package:flutter/material.dart';

import '../../config/theme/app_shadows.dart';
import '../../config/theme/app_spacing.dart';

/// Tarjeta estándar de la app: reemplaza el patrón repetido de
/// `Container(decoration: BoxDecoration(boxShadow: [...], borderRadius: ...))`
/// que aparecía copiado y pegado en varias pantallas (incluidas 5 veces
/// idénticas dentro de `SpecialistStack`).
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;
  final List<BoxShadow>? shadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.color,
    this.radius = 12,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow ?? AppShadows.card,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
