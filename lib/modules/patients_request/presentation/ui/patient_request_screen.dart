import 'package:emotions_and_care_v1/helpers/paths.dart';
import 'package:emotions_and_care_v1/modules/patients_request/presentation/logic/patient_request_cubit.dart';
import 'package:emotions_and_care_v1/widgets/header_specialist_widget.dart';

class PatientRequestScreen extends StatefulWidget {
  final List<PatientRequest> patientsRequest;
  final Function(PatientRequest) onItemTap;
  final int userId;
  const PatientRequestScreen(
      {super.key,
      required this.patientsRequest,
      required this.onItemTap,
      required this.userId});

  @override
  State<PatientRequestScreen> createState() => _PatientRequestScreenState();
}

class _PatientRequestScreenState extends State<PatientRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSpecialistWidget(
          title: "Solicitudes de pacientes",
          isForReturn: true,
          context: context),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: RefreshIndicator(
          onRefresh: () async {
            context
                .read<PatientsRequestCubit>()
                .getPatientsRequestList(widget.userId);
          },
          child: widget.patientsRequest.isEmpty
              ? const AppEmptyState(
                  icon: Icons.group_add_rounded,
                  title: 'Sin solicitudes pendientes',
                  message:
                      'Cuando un paciente solicite vincularse, aparecerá aquí.',
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  child: ListView(
                    children: itemsRequestList(
                      context,
                      widget.patientsRequest,
                      widget.onItemTap,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

List<Widget> itemsRequestList(BuildContext context,
    List<PatientRequest> patientsRequest, Function onTap) {
  final List<Widget> items = [];

  items.add(const SizedBox(height: AppSpacing.sm));
  for (final PatientRequest patientRequest in patientsRequest) {
    items.add(containerItem(
      context,
      Colors.white,
      patientRequest.patient.name!,
      patientRequest.patient.email!,
      patientRequest.patient.sex ?? '',
      () {
        onTap(patientRequest);
      },
    ));

    items.add(const SizedBox(height: AppSpacing.sm));
  }
  return items;
}
