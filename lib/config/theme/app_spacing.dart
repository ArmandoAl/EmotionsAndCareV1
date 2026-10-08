/// Escala de espaciado. Úsala en vez de números sueltos en `EdgeInsets`/
/// `SizedBox` para que el ritmo visual sea consistente entre pantallas.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Escala de radios de borde.
class AppRadius {
  const AppRadius._();

  static const double sm = 8;

  /// Radio por defecto de tarjetas/botones.
  static const double md = 12;
  static const double lg = 16;

  /// Hojas modales, tarjetas "hero".
  static const double xl = 24;
  static const double pill = 999;
}
