import '../demo/widgets/demo_svg.dart';
import '../helpers/paths.dart';

Future<void> showItemsDialog(
  BuildContext context,
  String title,
  int position,
  UICubit uiCubit,
  UIState uiState, {
  bool isEmply = false,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title, style: const TextStyle(color: Colors.black)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.4,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: title == "Tus stickers"
                ? uiState.stickers!.length
                : uiState.flowers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  final authCubit = context.read<BegginCubit>();

                  if (title == "Tus stickers") {
                    uiCubit.setStickerInUse(authCubit.state.patientModel!.id!,
                        uiState.stickers![index], position);

                    if (authCubit.state.registerPatientFlow! ==
                        "firstTestCompleted") {
                      await showMessageDialog(
                          dimiss: false,
                          context,
                          "",
                          "¡Registro completado! |Ya formas parte de Emotions&Care. Ahora puedes explorar la aplicación y descubrir todas sus funcionalidades, haz de Emotions&Care tu espacio personal de bienestar emocional. |Y recuerda que: ¡Estamos aquí para apoyarte en cada paso del camino! |-Emotions&Care ",
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final authCubit = getIt<BegginCubit>();

                                if (authCubit.state.registerPatientFlow !=
                                    "registerSuccess") {
                                  final userProvider =
                                      context.read<BegginCubit>();
                                  userProvider.setRegisterFlow(
                                      userProvider.state.patientModel!.id!,
                                      "registerSuccess");
                                }

                                if (context.mounted) {
                                  Navigator.of(context).pop();

                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text("Aceptar"),
                            ),
                          ]);
                    }

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    uiCubit.setFlowerInInterface(
                        authCubit.state.patientModel!.id!,
                        uiState.flowers[index],
                        position);

                    if (authCubit.state.registerPatientFlow! ==
                        "firstTestCompleted") {
                      await showMessageDialog(
                        context,
                        "Añade stickers a tu jardín",
                        "Puedes decorar tu jardín con stickers, el verlos será un recordatorio de la importancia de celebrar cada pequeño logro.",
                      );
                    }

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: title == "Tus stickers"
                    ? demoSvg(
                        uiState.stickers![index].url ?? "",
                        placeholderBuilder: (context) =>
                            const CircularProgressIndicator(),
                        fit: BoxFit.fill,
                      )
                    : demoSvg(
                        uiState.flowers[index].flower
                            .urls![uiState.flowers[index].state].url,
                        placeholderBuilder: (context) =>
                            const CircularProgressIndicator(),
                        fit: BoxFit.fill,
                      ),
              );
            },
          ),
        ),
        actions: [
          //solo si hay un sitcker en esta posicion

          if (isEmply == false && title == "Tus stickers")
            TextButton(
              onPressed: () {
                if (title == "Tus stickers") {
                  final authcubit = context.read<BegginCubit>();

                  uiCubit.removeSticker(
                      authcubit.state.patientModel!.id!, position + 1);
                } else {
                  // uiCubit.removeFlower(uiState.flowers[position]);
                }

                Navigator.of(context).pop();
              },
              child: const Text("Quitar del jardín", style: TextStyle()),
            ),
        ],
      );
    },
  );
}

Future<void> showCustomDialog(
    BuildContext context, UICubit uiCubit, int pattientId) async {
  //l want that the dialog has a background image

  AnimationController animationController = AnimationController(
    vsync: Navigator.of(context),
    duration:
        const Duration(milliseconds: 500), // Changed to 500ms for better effect
  );

  Animation<double> scaleAnimation = Tween<double>(
    begin: 1.0,
    end: 1.1,
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ),
  );

  animationController.repeat(reverse: true);
  final userFlower = uiCubit.state.currentFlower;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          final notificationModel =
              state.items.isEmpty ? null : state.items.first;

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.paper),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        notificationModel?.title ?? "",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                notificationModel?.description ?? "",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
                                ),
                              ),
                              notificationModel?.type ==
                                      NotificationType.sticker
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: demoSvg(
                                        notificationModel?.url ?? "",
                                        placeholderBuilder: (context) =>
                                            const CircularProgressIndicator(),
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    notificationModel?.type ==
                            NotificationType.notificacionRecomendacion
                        ? Row(
                            children: [
                              const Spacer(),
                              const Text("Completado: ",
                                  style: TextStyle(color: Colors.black)),
                              Checkbox(
                                  value: notificationModel?.completed,
                                  onChanged: (value) {
                                    context
                                        .read<HomeCubit>()
                                        .changeNotificationCompleteStatud(
                                          notificationModel?.id ?? 0,
                                          notificationModel?.idRecomendation ??
                                              0,
                                          pattientId,
                                        );

                                    //haz pop despues de 2 segundos
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      if (context.mounted) {
                                        context
                                            .read<HomeCubit>()
                                            .deleteNotification(
                                                notificationModel?.id ?? 0);

                                        Navigator.of(context).pop();
                                      }
                                    });
                                  }),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    notificationModel?.type ==
                            NotificationType.notificacionRecomendacion
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final homeCubit = context.read<HomeCubit>();
                                  homeCubit.posone(notificationModel?.id ?? 0);

                                  Navigator.of(context).pop();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text("Mas tarde",
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          )
                        : const SizedBox(),
                    notificationModel?.type == NotificationType.sticker
                        ? Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final uiCubit = getIt<UICubit>();

                                  uiCubit.addSticker(StickerModel(
                                    id: notificationModel?.id,
                                    url: notificationModel?.url,
                                  ));

                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(),
                                child: const Text(
                                  "Recoger sticker",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    notificationModel?.type ==
                            NotificationType.notificacionRecomendacion
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015)
                        : const SizedBox(),
                    if (userFlower != null &&
                        userFlower.state < 5 &&
                        notificationModel?.type ==
                            NotificationType.growNotifications)
                      Row(
                        children: [
                          AnimatedBuilder(
                            animation: animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: scaleAnimation.value,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final BegginCubit begginCubit =
                                        context.read<BegginCubit>();
                                    final HomeCubit homeCubit =
                                        context.read<HomeCubit>();

                                    if (userFlower.state < 5) {
                                      begginCubit
                                          .changeStatus(BegginStatus.growing);

                                      homeCubit.growFlowerinBack(
                                          begginCubit.state.patientModel!.id!,
                                          uiCubit.state.currentFlower!
                                              .userFlowerId);
                                    }

                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text(
                                    "Crecer mi planta",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const Spacer(),
                        ],
                      )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showMessageDialog(
  BuildContext context,
  String title,
  String message, {
  bool dimiss = true,
  List<Widget>? actions,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: dimiss,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message.replaceAll("|", "\n"),
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
        actions: actions ??
            [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
      );
    },
  );
}

Future<void> showLoadingdialog(String message, BuildContext context,
    Future<void> Function() function) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(message),
          ],
        ),
      );
    },
  );

  await function();
}
