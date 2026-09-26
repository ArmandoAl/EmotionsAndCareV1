import 'package:flutter/material.dart';

/// Spinner de marca estandarizado, para reemplazar los
/// `CircularProgressIndicator` sueltos (con o sin color propio) repartidos
/// por la app. Las animaciones de carga "grandes" (Lottie del cerebro) se
/// conservan donde ya existían — este widget es para los loaders puntuales
/// dentro de una pantalla (botones, secciones, listas).
///
/// Respeta `MediaQuery.disableAnimations`: si el usuario/dispositivo pide
/// reducir movimiento, se muestra un ícono estático en vez de un spinner.
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoadingIndicator({super.key, this.size = 28, this.color});

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return Icon(Icons.hourglass_top_rounded, size: size, color: effectiveColor);
    }

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size / 12,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
      ),
    );
  }
}
