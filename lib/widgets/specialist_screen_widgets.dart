import 'package:table_calendar/table_calendar.dart';
import '../helpers/paths.dart';

Future<void> showTableCaledarBottomSheet(
    {required BuildContext context,
    required DateTime initialDate,
    required Function(DateTime) onDaySelected}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        child: TableCalendar(
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronVisible: false,
            rightChevronVisible: false,
            headerMargin:
                const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.sm),
            titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.shadowWarm) ??
                const TextStyle(),
            titleTextFormatter: (date, locale) =>
                '${Utils.getMonthName(date.month)} ${date.year}',
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: const TextStyle(color: AppColors.shadowWarm),
            weekendTextStyle: const TextStyle(color: AppColors.shadowWarm),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(color: AppColors.shadowWarm),
          ),
          firstDay: DateTime.now().toLocal(),
          lastDay: DateTime.now().toLocal().add(const Duration(days: 90)),
          focusedDay: (initialDate.isBefore(DateTime.now().toLocal())
              ? DateTime.now().toLocal()
              : initialDate),
          calendarFormat: CalendarFormat.month,
          onDaySelected: (selectedDay, focusedDay) {
            onDaySelected(selectedDay);
            Navigator.pop(context);
          },
        ),
      );
    },
  );

  return Future.value();
}

Widget specialistWidget(
    {required BuildContext context,
    required SpecialistModel? specialist,
    required PatientModel? patientModel,
    required bool isPatient}) {
  final ColorScheme scheme = Theme.of(context).colorScheme;
  if (patientModel!.specialist == null) {
    return AppCard(
      color: scheme.primaryContainer,
      onTap: () {
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchSpecialistController(
              patientModel: getIt<BegginCubit>().state.patientModel!,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Icon(Icons.person_search_rounded, color: scheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'No hay un especialista asignado, haz clic para encontrar uno',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.shadowWarm),
            ),
          ),
        ],
      ),
    );
  } else {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Especialista: ${patientModel.specialist!.name}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.shadowWarm),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Correo: ${patientModel.specialist!.email}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.shadowWarm),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Teléfono: ${patientModel.specialist!.phone}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.shadowWarm),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.person_rounded, color: scheme.primary, size: 28),
        ],
      ),
    );
  }
}
