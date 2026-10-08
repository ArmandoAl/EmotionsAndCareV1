import '../../../../../helpers/paths.dart';

class UserCartsController extends StatefulWidget {
  final PatientModel? patientModel;
  final SpecialistModel? specialistModel;
  final bool isPatient;
  const UserCartsController(
      {super.key,
      this.patientModel,
      this.specialistModel,
      required this.isPatient});

  @override
  State<UserCartsController> createState() => _UserCartsControllerState();
}

class _UserCartsControllerState extends State<UserCartsController> {
  int index = 0;

  void updateIndex(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  void initState() {
    context.read<CommunityCubit>().getCartFromUser(
        widget.isPatient
            ? widget.patientModel!.id!
            : widget.specialistModel!.id!,
        widget.isPatient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        if (state.status == CommunityStatus.loading) {
          return const Scaffold(
            body: Center(child: AppLoadingIndicator()),
          );
        }

        if (state.status == CommunityStatus.error) {
          return Scaffold(
            appBar: const HeaderWidget(title: "", isForReturn: true),
            body: AppErrorState(
              message: 'No pudimos cargar tu buzón.',
              onRetry: () => context.read<CommunityCubit>().getCartFromUser(
                  widget.isPatient
                      ? widget.patientModel!.id!
                      : widget.specialistModel!.id!,
                  widget.isPatient),
            ),
          );
        }

        final userId = widget.isPatient
            ? widget.patientModel!.id
            : widget.specialistModel!.id;
        //cartas en las que el usuario es el autor
        final sentCarts = state.cartFromUser
            .where((element) =>
                element.respuestas.isNotEmpty &&
                element.respuestas
                    .any((element) => element.idReceptor == userId))
            .toList();
        //cambiar, se tiene que agregar en el CartaModel un idReceptor para poder hacer la comparacion
        final recievedCarts = state.cartFromUser
            .where((element) => element.idEmisor == userId)
            .toList();

        return Scaffold(
          appBar: const HeaderWidget(title: "", isForReturn: true),
          body: UserCartsScreen(
            carts: index == 1 ? sentCarts : recievedCarts,
            index: index,
            updateIndex: updateIndex,
            userId: userId!,
          ),
        );
      },
    );
  }
}
