import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import '../config/theme/app_shadows.dart';
import '../config/theme/app_spacing.dart';

Widget communityMenuItem(
  BuildContext context,
  String title,
  Icon icon,
  void Function() onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          icon,
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.shadowWarm),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              color: AppColors.shadowWarm.withOpacity(0.5)),
        ],
      ),
    ),
  );
}
