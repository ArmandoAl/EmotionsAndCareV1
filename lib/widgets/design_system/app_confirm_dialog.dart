import 'package:flutter/material.dart';

import 'app_button.dart';

/// Diálogo de confirmación estándar. Reemplaza los `AlertDialog` bespoke
/// para acciones destructivas/irreversibles (eliminar nota, eliminar cita,
/// eliminar cuenta) y se usa también para las dos confirmaciones nuevas
/// que agrega este rediseño: cerrar sesión y rechazar una solicitud/cita.
///
/// Devuelve `true` si el usuario confirmó, `false`/`null` si canceló o
/// cerró el diálogo. No ejecuta ninguna acción por sí mismo: quien llama
/// decide qué hacer con el resultado (el callback existente no cambia).
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
  bool isDestructive = false,
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        AppButton.text(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        isDestructive
            ? AppButton.destructive(
                label: confirmLabel,
                onPressed: () => Navigator.of(context).pop(true),
              )
            : AppButton(
                label: confirmLabel,
                onPressed: () => Navigator.of(context).pop(true),
              ),
      ],
    ),
  );
  return result ?? false;
}
