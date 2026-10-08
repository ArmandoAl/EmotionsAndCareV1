import 'package:flutter/material.dart';

import '../../config/theme/app_spacing.dart';
import 'app_button.dart';

/// Estado de error estándar con acción de reintentar. Antes de este
/// rediseño, varios cubits (`PattientsDatesCubit`, `PattientsCubit`,
/// `PatientsRequestCubit`) emitían un estado de error que ninguna pantalla
/// renderizaba (caían en el mismo layout que "lista vacía", mostrando el
/// mensaje equivocado). Este widget les da una UI dedicada real.
class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.message = 'Ocurrió un error al cargar la información.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.error.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline_rounded, size: 32, color: scheme.error),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Algo no salió bien',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: 'Reintentar', onPressed: onRetry, icon: Icons.refresh_rounded),
            ],
          ],
        ),
      ),
    );
  }
}
