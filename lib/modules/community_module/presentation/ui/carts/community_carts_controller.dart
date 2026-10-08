import 'package:lottie/lottie.dart';
import '../../../../../helpers/paths.dart';

class CommunityCartsControoler extends StatefulWidget {
  final PatientModel? patient;
  final SpecialistModel? specialist;
  final bool isPatient;
  const CommunityCartsControoler(
      {super.key, this.patient, this.specialist, required this.isPatient});

  @override
  State<CommunityCartsControoler> createState() =>
      _CommunityCartsControolerState();
}

class _CommunityCartsControolerState extends State<CommunityCartsControoler> {
  @override
  void initState() {
    context.read<CommunityCubit>().initCommunity(
          widget.isPatient ? widget.patient!.id! : widget.specialist!.id!,
        );

    // //todo: remove after expo
    context.read<CommunityCubit>().getCartFromUser(
          widget.isPatient ? widget.patient!.id! : widget.specialist!.id!,
          widget.isPatient,
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        if (state.status == CommunityStatus.loading) {
          return Scaffold(
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Lottie.asset(Assets.brainLoading),
              ),
            ),
          );
        }

        if (state.status == CommunityStatus.error) {
          return Scaffold(
            appBar: const HeaderWidget(title: 'Cartas de apoyo', isForReturn: true),
            body: AppErrorState(
              message: 'No pudimos cargar las cartas de la comunidad.',
              onRetry: () => context.read<CommunityCubit>().initCommunity(
                    widget.isPatient ? widget.patient!.id! : widget.specialist!.id!,
                  ),
            ),
          );
        }

        final carts = state.cartFromCommunity;

        return Scaffold(
            appBar: HeaderWidget(
              title: 'Cartas de apoyo',
              isForReturn: true,
              actions: widget.isPatient
                  ? [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserCartsController(
                                          patientModel: widget.patient,
                                          specialistModel: widget.specialist,
                                          isPatient: widget.isPatient,
                                        )));
                          },
                          child: const Text('Buzón')),
                      const SizedBox(width: AppSpacing.xs),
                    ]
                  : null,
            ),
            body: CommunityCartsScreen(
              carts: carts,
              onCartTap: (CartModel cart) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswerCartScreen(
                      cart: cart,
                      userId: widget.isPatient
                          ? widget.patient!.id!
                          : widget.specialist!.id!,
                      letraEmisor: widget.isPatient
                          ? widget.patient!.name!
                          : widget.specialist!.name!,
                      onSend: (CartResponse cartResponse) async {
                        ResponseWithAchivement res =
                            await context.read<CommunityCubit>().addResponse(
                                  cartResponse,
                                  cart.id!,
                                  widget.isPatient,
                                  widget.isPatient
                                      ? widget.patient!.id!
                                      : widget.specialist!.id!,
                                );
                        if (res.achivementId != null) {
                          final UICubit uiProvider = getIt<UICubit>();

                          final achivement =
                              uiProvider.getAchivement(res.achivementId!);

                          if (context.mounted && achivement != null) {
                            await showStickerDialog(context, achivement);
                          }
                        }
                      },
                      //animation
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: widget.isPatient == false
                ? null
                : FloatingActionButton(
                    heroTag: null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewRequestCartScreen(
                                userId: widget.isPatient
                                    ? widget.patient!.id!
                                    : widget.specialist!.id!,
                                userLetter: widget.isPatient
                                    ? widget.patient!.name![0]
                                    : widget.specialist!.name![0],
                                isPatient: widget.isPatient,
                                onSend: (CartModel cart) async {
                                  CartWithAchivement res = await context
                                      .read<CommunityCubit>()
                                      .addCart(
                                        cart,
                                        widget.isPatient
                                            ? widget.patient!.id!
                                            : widget.specialist!.id!,
                                        widget.isPatient,
                                      );

                                  if (res.achivementId != null &&
                                      context.mounted) {
                                    final UICubit uiProvider = getIt<UICubit>();

                                    final achivement = uiProvider
                                        .getAchivement(res.achivementId!);

                                    if (achivement == null) return;

                                    if (context.mounted) {
                                      await showStickerDialog(
                                          context, achivement);
                                    }
                                  }
                                })),
                      );
                    },
                    child: Icon(Icons.edit_rounded,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ));
      },
    );
  }
}
