import '../../../../helpers/paths.dart';

class PattientsDatesController extends StatefulWidget {
  final int idUser;
  const PattientsDatesController({super.key, required this.idUser});

  @override
  State<PattientsDatesController> createState() =>
      _PattientsDatesControllerState();
}

class _PattientsDatesControllerState extends State<PattientsDatesController> {
  @override
  void initState() {
    if (context.read<PattientsDatesCubit>().state.dates.isEmpty) {
      context.read<PattientsDatesCubit>().getPattientsDates(widget.idUser);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PattientsDatesCubit, PattientsDatesState>(
        bloc: context.read<PattientsDatesCubit>(),
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.status == PattientsDatesStatus.loading) {
            return const Scaffold(
              body: Center(child: AppLoadingIndicator()),
            );
          }

          if (state.status == PattientsDatesStatus.error) {
            return Scaffold(
              appBar: const HeaderWidget(
                  title: "Solicitudes de citas", isForReturn: true),
              body: AppErrorState(
                message: 'No pudimos cargar las solicitudes de citas.',
                onRetry: () => context
                    .read<PattientsDatesCubit>()
                    .getPattientsDates(widget.idUser),
              ),
            );
          }

          final dates = state.dates;

          if (dates.isEmpty) {
            return Scaffold(
                appBar: HeaderWidget(
                  title: "Solicitudes de citas",
                  isForReturn: true,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.replay_rounded,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: () {
                        context
                            .read<PattientsDatesCubit>()
                            .getPattientsDates(widget.idUser);
                      },
                    )
                  ],
                ),
                body: const AppEmptyState(
                  icon: Icons.event_available_rounded,
                  title: 'Sin solicitudes pendientes',
                  message:
                      'No tienes solicitudes de citas pendientes. Puedes dirigirte a la sección de configuración para ver tu código de vinculación y compartirlo con tus pacientes.',
                ));
          }

          return SpecialistDatesScreen(
            title: 'Solcitudes de citas',
            datesRequest: dates,
            userId: widget.idUser,
            onItemTap: (DateModel date) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DateDetail(
                            speciaistId: widget.idUser,
                            date: date,
                            specialist:
                                getIt<BegginCubit>().state.specialistModel!,
                          )));
            },
          );
        });
  }
}
