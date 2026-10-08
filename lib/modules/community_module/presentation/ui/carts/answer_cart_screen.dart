import '../../../../../demo/widgets/demo_svg.dart';

import '../../../../../helpers/paths.dart';

class AnswerCartScreen extends StatefulWidget {
  final CartModel cart;
  final int userId;
  final String letraEmisor;
  final Function onSend;
  final bool isFromBuzon;
  final bool itsFromAnotherUser;
  const AnswerCartScreen(
      {super.key,
      required this.cart,
      required this.userId,
      required this.letraEmisor,
      required this.onSend,
      this.isFromBuzon = false,
      this.itsFromAnotherUser = false});

  @override
  State<AnswerCartScreen> createState() => _AnswerCartScreenState();
}

class _AnswerCartScreenState extends State<AnswerCartScreen> {
  TextEditingController controller = TextEditingController();
  final PageController pageController = PageController();
  bool isloading = false;
  StickerModel? sticker;
  final uiCubit = getIt<UICubit>();

  @override
  void initState() {
    super.initState();
    if (widget.itsFromAnotherUser) {
      sticker = widget.cart.respuestas
                  .where((element) => element.idReceptor == widget.userId)
                  .first
                  .idSticker !=
              null
          ? uiCubit.state.stickers!.firstWhere(
              (element) =>
                  element.id ==
                  widget.cart.respuestas
                      .where((element) => element.idReceptor == widget.userId)
                      .first
                      .idSticker,
              orElse: () => StickerModel(
                id: null,
                url: null,
              ),
            )
          : StickerModel(
              id: null,
              url: null,
            );

      if (sticker!.id == null) {
        sticker = null;
      }
    }
  }

  void moveToNextCard() {
    if (pageController.page!.toInt() + 1 < widget.cart.respuestas.length) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void moveToPreviousCard() {
    if (pageController.page!.toInt() - 1 >= 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(
          title: 'Escribe una carta para - ${widget.cart.letraEmisor[0]}',
          isForReturn: true),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            cartWidget(
              context,
              widget.cart,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06),
                  child: widget.isFromBuzon == false
                      ? responseWidget(
                          context,
                          "- ${widget.letraEmisor[0]}",
                          controller,
                          null,
                          "Escribe tu respuesta",
                          stickerModel: sticker,
                          sticker: true,
                          onStickerPressed: () async {
                            await showStickersForCartDialog(
                              context,
                              context.read<UICubit>(),
                              context.read<UICubit>().state,
                              isEmply: sticker == null,
                              onStickerSelected: (sticker) {
                                setState(() {
                                  this.sticker = sticker;
                                });
                              },
                            );
                          },
                        )
                      : widget.itsFromAnotherUser == false
                          ? PageView.builder(
                              controller: pageController,
                              itemCount: widget.cart.respuestas.length,
                              itemBuilder: (context, index) {
                                StickerModel stickerContent;
                                if (widget.cart.respuestas[index].idSticker !=
                                    null) {
                                  //revisar si el sticker esta en la lista de stickers del usuario
                                  stickerContent = getIt<UICubit>()
                                      .state
                                      .stickers!
                                      .firstWhere(
                                        (element) =>
                                            element.id ==
                                            widget.cart.respuestas[index]
                                                .idSticker,
                                        orElse: () => StickerModel(
                                          id: null,
                                          url: null,
                                        ),
                                      );
                                } else {
                                  stickerContent = StickerModel(
                                    id: null,
                                    url: null,
                                  );
                                }

                                return responseWidget(
                                  context,
                                  "- ${widget.letraEmisor[0]}",
                                  controller,
                                  widget.cart.respuestas[index].contenido,
                                  "Escribe tu respuesta",
                                  stickerModel: stickerContent.id != null
                                      ? stickerContent
                                      : sticker,
                                  sticker: false,
                                  onStickerPressed: () async {
                                    await showStickersForCartDialog(
                                      context,
                                      context.read<UICubit>(),
                                      context.read<UICubit>().state,
                                      isEmply: sticker == null,
                                      onStickerSelected: (sticker) {
                                        setState(() {
                                          this.sticker = sticker;
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                            )
                          : responseWidget(
                              context,
                              "- ${widget.letraEmisor[0]}",
                              controller,
                              widget.cart.respuestas
                                  .where((element) =>
                                      element.idReceptor == widget.userId)
                                  .first
                                  .contenido,
                              "Escribe tu respuesta",
                              stickerModel: sticker,
                              sticker: false,
                              onStickerPressed: () async {},
                            )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            widget.isFromBuzon == true &&
                    widget.cart.respuestas
                        .where((element) => element.idReceptor == widget.userId)
                        .isEmpty &&
                    widget.cart.respuestas.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: moveToPreviousCard,
                        icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
                        color: AppColors.shadowWarm,
                      ),
                      Text(
                        "Navegar",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppColors.shadowWarm),
                      ),
                      IconButton(
                        onPressed: moveToNextCard,
                        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 22),
                        color: AppColors.shadowWarm,
                      ),
                    ],
                  )
                : const SizedBox(),
            widget.isFromBuzon == false
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: AppButton(
                      label: 'Enviar',
                      isLoading: isloading,
                      expand: true,
                      onPressed: () async {
                        if (isloading) return;

                        if (controller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'El contenido de la carta no puede estar vacío'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isloading = true;
                        });

                        final cartResponse = CartResponse(
                          id: null,
                          contenido: controller.text,
                          idReceptor: widget.userId,
                          letraReceptor: widget.letraEmisor[0],
                          leida: false,
                          idSticker: sticker?.id,
                        );

                        await widget.onSend(cartResponse);

                        setState(() {
                          isloading = false;
                        });

                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

Future<void> showStickersForCartDialog(
  BuildContext context,
  UICubit uiCubit,
  UIState uiState, {
  bool isEmply = false,
  required Function onStickerSelected,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text("Stickers",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.4,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: uiState.stickers!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () async {
                    onStickerSelected(
                      uiState.stickers![index],
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: demoSvg(
                    uiState.stickers![index].url ?? "",
                    placeholderBuilder: (context) => const AppLoadingIndicator(),
                    fit: BoxFit.fill,
                  ));
            },
          ),
        ),
        actions: [
          //solo si hay un sitcker en esta posicion

          if (isEmply == false)
            AppButton.text(
              label: "Quitar",
              onPressed: () {
                onStickerSelected(null);

                Navigator.of(context).pop();
              },
            ),
        ],
      );
    },
  );
}
