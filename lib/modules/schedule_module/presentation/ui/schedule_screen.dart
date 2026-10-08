import 'package:table_calendar/table_calendar.dart';

import '../../../../helpers/paths.dart';

class ScheduleScreen extends StatefulWidget {
  static const String route = 'schedule';
  final List<DateModel> dates;
  final bool isPatient;

  final Function? onDateTap;
  final Future<void> Function() onRefresh;
  const ScheduleScreen(
      {super.key,
      required this.dates,
      required this.isPatient,
      this.onDateTap,
      required this.onRefresh});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateModel? _selectedDate;
  PatientModel? patient;
  SpecialistModel? specialist;

  @override
  void initState() {
    super.initState();
    if (widget.isPatient) {
      patient = getIt<BegginCubit>().state.patientModel;
    } else {
      specialist = getIt<BegginCubit>().state.specialistModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async {
          await widget.onRefresh();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TableCalendar(
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: true,
                  rightChevronVisible: true,
                  rightChevronIcon: const Icon(
                    Icons.chevron_right_rounded,
                    size: 26,
                    color: AppColors.shadowWarm,
                  ),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left_rounded,
                    size: 26,
                    color: AppColors.shadowWarm,
                  ),
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
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.shadowWarm.withOpacity(0.7),
                  ),
                  weekendStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.shadowWarm.withOpacity(0.7),
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(color: AppColors.shadowWarm),
                  weekendTextStyle: const TextStyle(color: AppColors.shadowWarm),
                  outsideTextStyle:
                      TextStyle(color: AppColors.shadowWarm.withOpacity(0.35)),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(color: AppColors.shadowWarm),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                focusedDay: DateTime.now().toLocal(),
                firstDay: DateTime(1990).toLocal(),
                lastDay: DateTime(2050).toLocal(),
                eventLoader: (day) {
                  return widget.dates
                      .where((element) =>
                          element.date!.day == day.day &&
                          element.date!.month == day.month &&
                          element.date!.year == day.year)
                      .toList();
                },
                onDaySelected: (selectedDay, focusedDay) {
                  for (var date in widget.dates) {
                    if (date.date!.day == selectedDay.day &&
                        date.date!.month == selectedDay.month &&
                        date.date!.year == selectedDay.year) {
                      setState(() {
                        _selectedDate = date;
                      });

                      widget.onDateTap!(date);

                      return;
                    }
                  }
                },
                selectedDayPredicate: (day) {
                  return _selectedDate != null &&
                      day.day == _selectedDate!.date!.day &&
                      day.month == _selectedDate!.date!.month &&
                      day.year == _selectedDate!.date!.year;
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
                child: Padding(
              padding: widget.isPatient
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.xl),
                    topRight: Radius.circular(AppRadius.xl),
                  ),
                ),
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: containerContentWidget(context, _selectedDate,
                    widget.isPatient, patient, specialist, widget.dates),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
