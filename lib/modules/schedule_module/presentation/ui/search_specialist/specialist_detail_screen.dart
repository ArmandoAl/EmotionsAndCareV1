import '../../../../../helpers/paths.dart';

class SpecialistDetailScreen extends StatefulWidget {
  final PatientModel? patientModel;
  final SpecialistModel? specialistModel;
  final Future<bool> Function(String) syncByCode;
  const SpecialistDetailScreen(
      {super.key,
      required this.patientModel,
      required this.specialistModel,
      required this.syncByCode});

  @override
  State<SpecialistDetailScreen> createState() => _SpecialistDetailScreenState();
}

class _SpecialistDetailScreenState extends State<SpecialistDetailScreen> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del especialista"),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(Icons.person_rounded,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(widget.specialistModel!.name!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.shadowWarm)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _infoRow(context, Icons.email_rounded, "Correo",
                      widget.specialistModel!.email!),
                  _infoRow(context, Icons.phone_rounded, "Teléfono",
                      widget.specialistModel!.phone!),
                  _infoRow(context, Icons.wc_rounded, "Sexo",
                      widget.specialistModel!.sex!),
                  _infoRow(context, Icons.cake_rounded, "Edad",
                      "${widget.specialistModel!.age} años"),
                  _infoRow(context, Icons.psychology_rounded, "Enfoque",
                      widget.specialistModel!.focus!),
                  _infoRow(
                      context,
                      Icons.business_rounded,
                      "Institución",
                      widget.specialistModel!.presentation != ""
                          ? widget.specialistModel!.presentation!
                          : "Sin institución"),
                  _infoRow(
                      context,
                      Icons.location_on_rounded,
                      "Ubicación",
                      widget.specialistModel!.ubication != ""
                          ? widget.specialistModel!.ubication!
                          : "Sin ubicación definida"),
                  _infoRow(
                      context,
                      Icons.description_rounded,
                      "Carta de presentación",
                      widget.specialistModel!.institution != ""
                          ? widget.specialistModel!.institution!
                          : "Sin carta de presentación"),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                      expand: true,
                      isLoading: isloading,
                      label: "Solicitar vinculación",
                      onPressed: () async {
                        setState(() {
                          isloading = !isloading;
                        });
                        bool result = await widget.syncByCode(
                            widget.specialistModel!.tokenForRelate!);
                        setState(() {
                          isloading = !isloading;
                        });

                        if (context.mounted) {
                          await showConfirmTextDialog(
                              context,
                              result
                                  ? "Solicitud enviada, te notificaremos cuando el especialista responda a tu solicitud"
                                  : "Error al enviar la solicitud, por favor intenta de nuevo más tarde");
                        }
                        if (context.mounted) Navigator.pop(context);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7))),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(value,
            textAlign: TextAlign.justify,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.shadowWarm)),
      ],
    ),
  );
}

Future<void> showConfirmTextDialog(BuildContext context, String text) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmación",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        content: Text(text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.shadowWarm)),
        actions: <Widget>[
          AppButton.text(
            label: 'Aceptar',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
