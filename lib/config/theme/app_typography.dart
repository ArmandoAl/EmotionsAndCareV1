import 'package:flutter/material.dart';

/// Escala tipográfica de la app, construida sobre Gilroy (ya incluida en
/// el bundle). Reemplaza el patrón disperso de `fontSize:
/// MediaQuery.of(context).size.width * 0.0X` que hoy define cada pantalla
/// por su cuenta con un `TextTheme` completo y predecible.
class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Gilroy';

  static TextTheme textTheme(Color textPrimary, Color textSecondary) {
    TextStyle style(double size, FontWeight weight, Color color, {double? height, double? letterSpacing}) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    return TextTheme(
      displaySmall: style(32, FontWeight.w800, textPrimary, height: 1.15),
      headlineLarge: style(28, FontWeight.w700, textPrimary, height: 1.2),
      headlineMedium: style(24, FontWeight.w700, textPrimary, height: 1.2),
      headlineSmall: style(20, FontWeight.w700, textPrimary, height: 1.25),
      titleLarge: style(20, FontWeight.w700, textPrimary, height: 1.25),
      titleMedium: style(17, FontWeight.w500, textPrimary, height: 1.3),
      titleSmall: style(15, FontWeight.w500, textPrimary, height: 1.3),
      bodyLarge: style(16, FontWeight.w400, textPrimary, height: 1.4),
      bodyMedium: style(14, FontWeight.w400, textPrimary, height: 1.4),
      bodySmall: style(12, FontWeight.w400, textSecondary, height: 1.35),
      labelLarge: style(15, FontWeight.w500, textPrimary, letterSpacing: 0.1),
      labelMedium: style(13, FontWeight.w500, textSecondary, letterSpacing: 0.1),
      labelSmall: style(11, FontWeight.w500, textSecondary, letterSpacing: 0.2),
    );
  }
}
