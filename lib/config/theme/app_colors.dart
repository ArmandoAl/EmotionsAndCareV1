import 'package:flutter/material.dart';

/// Paleta semántica de Emotions & Care ("Jardín editorial").
///
/// Cálida, editorial y serena — evita el look de dashboard genérico o de
/// app infantil. `day` es el skin por defecto (índice 0 en
/// `UICubit.state.themes`); `night` es el segundo skin (índice 1).
/// Ambos comparten la misma estructura semántica para que el resto de la
/// app (que lee `Theme.of(context).colorScheme`) no necesite saber cuál
/// está activo.
class AppColors {
  const AppColors._();

  // ---- Skin "Día" ----
  static const Color dayBackground = Color(0xFFF7F3EC);
  static const Color daySurface = Color(0xFFFFFFFF);
  static const Color daySurfaceSunken = Color(0xFFEFE8DA);
  static const Color dayPrimary = Color(0xFF2F6F4E);
  static const Color dayPrimaryContainer = Color(0xFFE4EFE6);
  static const Color daySecondary = Color(0xFFC97B4A);
  static const Color dayTertiary = Color(0xFF7C6A9C);
  static const Color dayTextPrimary = Color(0xFF2B2620);
  static const Color dayTextSecondary = Color(0xFF6B6255);
  static const Color dayBorder = Color(0xFFE3DACB);
  static const Color daySuccess = Color(0xFF3B8859);
  static const Color dayWarning = Color(0xFFC48A1F);
  static const Color dayError = Color(0xFFB3432E);

  // ---- Skin "Noche" ----
  static const Color nightBackground = Color(0xFF1B211C);
  static const Color nightSurface = Color(0xFF242B25);
  static const Color nightSurfaceSunken = Color(0xFF2E362F);
  static const Color nightPrimary = Color(0xFF7FBE97);
  static const Color nightPrimaryContainer = Color(0xFF2C4536);
  static const Color nightSecondary = Color(0xFFE3A374);
  static const Color nightTertiary = Color(0xFFAFA0CC);
  static const Color nightTextPrimary = Color(0xFFF1EDE4);
  static const Color nightTextSecondary = Color(0xFFB7B0A2);
  static const Color nightBorder = Color(0xFF3A4239);
  static const Color nightSuccess = Color(0xFF7FBE97);
  static const Color nightWarning = Color(0xFFE0B355);
  static const Color nightError = Color(0xFFE17A63);

  /// Color de sombra "cálida" (negro tibio) usado por [AppShadows].
  static const Color shadowWarm = Color(0xFF2B2620);
}

// Nota: los colores semánticos de las emociones del diario y de la
// severidad de los cuestionarios NO viven aquí — siguen en
// lib/utils_functions/{emotions_utils,test_questions_colors,test_history_colors}.dart
// (y sus duplicados en lib/config/utils_functions/, preexistentes) para no
// tocar sus contratos; solo se armonizaron sus valores con esta paleta.
