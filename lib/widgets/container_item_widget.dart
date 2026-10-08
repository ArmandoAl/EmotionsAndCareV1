import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import '../config/theme/app_shadows.dart';
import '../config/theme/app_spacing.dart';

Widget containerItem(BuildContext context, Color color, String text,
    String subText, String trailingText, Function onTap,
    {bool hasHeader = false, IconData icon = Icons.arrow_forward_ios_rounded}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: hasHeader == false
            ? BorderRadius.circular(AppRadius.md)
            : const BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.md),
                bottomRight: Radius.circular(AppRadius.md),
              ),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: hasHeader == true ? AppShadows.none : AppShadows.card,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.shadowWarm),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      trailingText,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.shadowWarm),
                    ),
                  ],
                ),
                Text(subText,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7))),
              ],
            ),
          ),
          Icon(
            icon,
            color: AppColors.shadowWarm.withOpacity(0.5),
            size: 20,
          ),
        ],
      ),
    ),
  );
}
