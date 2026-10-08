import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Sombra única y cálida que reemplaza las 3-4 variantes de
/// `BoxShadow(Colors.grey...)` dispersas por la app (cada una con su propio
/// spread/blur/offset ligeramente distinto).
class AppShadows {
  const AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.shadowWarm.withOpacity(0.10),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  /// Sombra más suave para elementos flotantes pequeños (chips, stickers).
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.shadowWarm.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];

  static const List<BoxShadow> none = [];
}
