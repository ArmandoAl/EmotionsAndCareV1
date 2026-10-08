import '../helpers/paths.dart';

Widget containerContentWidget(
  BuildContext context,
  DateModel? date,
  bool isPatient,
  PatientModel? patientModel,
  SpecialistModel? especialistaModel,
  List<DateModel> dates,
) {
  final ColorScheme scheme = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    child: ListView(
      children: [
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewDateScreen(
                  isPatient: isPatient,
                  dates: dates,
                  onSave: (DateModel date, PatientModel patient) async {
                    if (isPatient) {
                      DateWithAchivement? res = await context
                          .read<ScheduleCubit>()
                          .addDate(
                              patient.id!, date, patientModel!.specialist!.id!);

                      if (res.achivementId != null && context.mounted) {
                        final UICubit uiProvider = context.read<UICubit>();

                        final achivement =
                            uiProvider.getAchivement(res.achivementId!);

                        if (context.mounted) {
                          await showStickerDialog(context, achivement!);
                        }
                      }
                    } else {
                      await context.read<ScheduleCubit>().addDateBySpecialist(
                          especialistaModel!.id!, date, patient);
                    }
                  },
                ),
              ),
            );
          },
          child: Row(
            children: [
              Icon(Icons.add_circle_rounded, color: scheme.onPrimary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  "Agendar cita",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: scheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        isPatient
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchSpecialistController(
                        patientModel: patientModel,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.person_search_rounded, color: scheme.onPrimary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        "Buscar especialista",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: scheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    ),
  );
}

class Utils {
  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Septiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';
      default:
        return '';
    }
  }
}
