import '../../../../helpers/paths.dart';
import '../../../../widgets/header_specialist_widget.dart';
import '../logic/patient_request_cubit.dart';

class PatientRequestDetail extends StatefulWidget {
  final int specialistId;
  final PatientRequest patientRequest;
  const PatientRequestDetail(
      {super.key, required this.specialistId, required this.patientRequest});

  @override
  State<PatientRequestDetail> createState() => _PatientRequestDetailState();
}

class _PatientRequestDetailState extends State<PatientRequestDetail> {
  bool isloading = false;
  bool aceptedLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSpecialistWidget(
        title: "",
        isForReturn: true,
        context: context,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Text(
                      widget.patientRequest.patient.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: AppColors.shadowWarm),
                    ),
                    Text(
                      "Fecha de solicitud: ${widget.patientRequest.date.day}/${widget.patientRequest.date.month}/${widget.patientRequest.date.year}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cake_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          "${widget.patientRequest.patient.age} años",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Icon(Icons.wc_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          widget.patientRequest.patient.sex!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.mail_rounded,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Correo electrónico",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              color: AppColors.shadowWarm
                                                  .withOpacity(0.7)),
                                    ),
                                    Text(
                                      widget.patientRequest.patient.email!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppColors.shadowWarm),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(Icons.phone_rounded,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teléfono",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              color: AppColors.shadowWarm
                                                  .withOpacity(0.7)),
                                    ),
                                    Text(
                                      widget.patientRequest.patient.phone!,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppColors.shadowWarm),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: AppButton.destructive(
                    label: 'Rechazar',
                    isLoading: isloading,
                    onPressed: () async {
                      final bool confirmed = await showAppConfirmDialog(
                        context,
                        title: 'Rechazar solicitud',
                        message:
                            '¿Estás seguro de que quieres rechazar la solicitud de ${widget.patientRequest.patient.name}?',
                        confirmLabel: 'Rechazar',
                        isDestructive: true,
                      );
                      if (!confirmed || !context.mounted) return;

                      setState(() {
                        isloading = true;
                      });

                      await context
                          .read<PatientsRequestCubit>()
                          .rejectPatientRequest(
                            widget.specialistId,
                            widget.patientRequest.patient.id!,
                            widget.patientRequest.id,
                          );

                      setState(() {
                        isloading = false;
                      });

                      if (context.mounted) Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: AppButton(
                    label: 'Aceptar',
                    isLoading: aceptedLoading,
                    onPressed: () async {
                      setState(() {
                        aceptedLoading = true;
                      });

                      final bool res = await context
                          .read<PatientsRequestCubit>()
                          .acceptPatientRequest(
                            widget.specialistId,
                            widget.patientRequest.patient.id!,
                            widget.patientRequest.id,
                          );

                      if (res && context.mounted) {
                        await showMessageDialog(
                            context, "", "Paciente aceptado correctamente");

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }

                      setState(() {
                        aceptedLoading = false;
                      });

                      if (context.mounted) Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
