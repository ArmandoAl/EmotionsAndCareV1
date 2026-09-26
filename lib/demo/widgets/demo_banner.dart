import 'package:flutter/material.dart';

import '../demo_config.dart';
import '../demo_reset.dart';

/// Franja fija que deja claro en todo momento que la sesión es una
/// demostración, con un acceso directo para reiniciarla.
class DemoBanner extends StatelessWidget {
  final Widget child;
  const DemoBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Importante: se usa una Column (no un Stack superpuesto) para que el
    // banner ocupe su propio espacio arriba y empuje el contenido hacia
    // abajo, en vez de taparlo. Como superposición, el banner terminaba
    // bloqueando el ícono del menú (drawer) de las pantallas que usan un
    // AppBar estándar pegado al borde superior.
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF0B3D91),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      kDemoBannerText,
                      style: TextStyle(color: Colors.white, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _confirmReset(context),
                    icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
                    label: const Text(
                      'Reiniciar demo',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: const Size(0, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reiniciar demostración'),
        content: const Text(
          'Esto borrará las notas, respuestas y cuestionarios que hayas '
          'hecho en esta demo y volverá al estado inicial. ¿Continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetDemoSession();
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}
