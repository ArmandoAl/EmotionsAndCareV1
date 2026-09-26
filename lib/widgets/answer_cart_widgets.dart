import '../demo/widgets/demo_svg.dart';

import '../helpers/paths.dart';

Widget cartWidget(BuildContext context, CartModel cart, {Function()? onTap}) {
  return GestureDetector(
    onTap: () async {
      if (onTap != null) {
        onTap();
      } else {
        await showCartDialog(context, cart);
      }
    },
    child: Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${cart.fechaCreacion!.day}/${cart.fechaCreacion!.month}/${cart.fechaCreacion!.year}",
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  cart.contenido,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.shadowWarm),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "- ${cart.letraEmisor}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.shadowWarm),
                ),
                const Spacer(),
                Text(
                  "${cart.respuestas.length} respuestas",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.shadowWarm.withOpacity(0.7),
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    ),
  );
}

Widget responseWidget(
  BuildContext context,
  String letra,
  TextEditingController controller,
  String? content,
  String hintText, {
  bool sticker = true,
  StickerModel? stickerModel,
  Function()? onStickerPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      boxShadow: AppShadows.card,
    ),
    child: Column(
      children: [
        Expanded(
            child: content == null
                ? TextField(
                    controller: controller,
                    maxLines: null,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.shadowWarm),
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(AppSpacing.lg),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      content,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.shadowWarm),
                    ),
                  )),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            const SizedBox(width: AppSpacing.sm),
            stickerModel != null
                ? IconButton(
                    onPressed: onStickerPressed,
                    icon: demoSvg(
                      stickerModel.url ?? "",
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                  )
                : sticker
                    ? IconButton(
                        onPressed: () {
                          onStickerPressed!();
                        },
                        icon: const Icon(Icons.sticky_note_2_rounded))
                    : const SizedBox.shrink(),
            const Spacer(),
            Text(
              letra,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.shadowWarm),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    ),
  );
}

Future<void> showCartDialog(BuildContext context, CartModel cart) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SingleChildScrollView(
                    child: Text(
                      cart.contenido,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.shadowWarm),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    "- ${cart.letraEmisor}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.shadowWarm),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      );
    },
  );
}
