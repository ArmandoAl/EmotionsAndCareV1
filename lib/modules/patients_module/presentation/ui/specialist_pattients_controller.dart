import 'package:emotions_and_care_v1/modules/patients_module/presentation/ui/specialiste_patients_items_screen.dart';

import '../../../../helpers/paths.dart';

class SpecialistPattientsController extends StatefulWidget {
  final int idUser;
  const SpecialistPattientsController({
    super.key,
    required this.idUser,
  });

  @override
  State<SpecialistPattientsController> createState() =>
      _SpecialistPattientsControllerState();
}

class _SpecialistPattientsControllerState
    extends State<SpecialistPattientsController> {
  @override
  void initState() {
    if (context.read<PattientsCubit>().state.patients.isEmpty) {
      context.read<PattientsCubit>().getPattients(widget.idUser);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PattientsCubit, PattientsState>(
        bloc: context.read<PattientsCubit>(),
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.status == PattientsStatus.loading) {
            return const Scaffold(
              body: Center(child: AppLoadingIndicator()),
            );
          }

          if (state.status == PattientsStatus.error) {
            return Scaffold(
              appBar: AppBar(title: const Text('Pacientes')),
              body: AppErrorState(
                message: 'No pudimos cargar tus pacientes.',
                onRetry: () =>
                    context.read<PattientsCubit>().getPattients(widget.idUser),
              ),
            );
          }

          final patients = state.patients;

          if (patients.isEmpty) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Pacientes'),
                ),
                body: const AppEmptyState(
                  icon: Icons.people_outline_rounded,
                  title: 'Aún no tienes pacientes',
                  message:
                      'Puedes dirigirte a la sección de configuración para ver tu código de vinculación y compartirlo con tus pacientes.',
                ));
          }

          return SpecialisPattientsScreen(
            title: 'Pacientes',
            pattients: patients,
            userId: widget.idUser,
            onItemTap: (PatientModel patient) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientDetail(
                            patient: patient,
                          )));
            },
          );
        });
  }
}
