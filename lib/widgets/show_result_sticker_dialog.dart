import '../helpers/paths.dart';

Future<void> showStikerDialog(BuildContext context, BegginCubit userCubit) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                    'Gracias por contestar nuestro cuestionario. Tenemos un pequeño regalo para ti.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.shadowWarm)),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text('¡Nuevo sticker desbloqueado!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: AppColors.shadowWarm)),
              ),
              const Image(
                image: AssetImage(Assets.cat),
                fit: BoxFit.cover,
              ),
              AppButton(
                label: 'Recoger sticker',
                onPressed: () async {
                  if (userCubit.state.registerPatientFlow == "register") {
                    userCubit.setRegisterFlow(userCubit.state.patientModel!.id!,
                        "firstTestCompleted");
                  }

                  // final uiProvider = getIt<UICubit>();
                  // uiProvider.addSticker(StickerModel(
                  //   id: 2,
                  //   url: Assets.cat,
                  // ));

                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
