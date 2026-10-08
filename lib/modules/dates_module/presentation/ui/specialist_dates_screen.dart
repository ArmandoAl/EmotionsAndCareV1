// ignore_for_file: unnecessary_null_comparison

import 'package:emotions_and_care_v1/widgets/header_specialist_widget.dart';

import '../../../../helpers/paths.dart';

class SpecialistDatesScreen extends StatefulWidget {
  final String title;
  final List<DateRequestModel> datesRequest;
  final Function(DateModel) onItemTap;
  final int userId;
  const SpecialistDatesScreen(
      {super.key,
      required this.title,
      required this.onItemTap,
      required this.datesRequest,
      required this.userId});

  @override
  State<SpecialistDatesScreen> createState() => _SpecialistDatesScreenState();
}

class _SpecialistDatesScreenState extends State<SpecialistDatesScreen> {
  List<DateModel> get dates {
    final List<DateModel> dates = [];
    for (final DateRequestModel dateRequest in widget.datesRequest) {
      if (dateRequest.date != null) {
        dates.add(dateRequest.date!);
      }
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSpecialistWidget(
          title: "Citas de los pacientes", isForReturn: true, context: context),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: RefreshIndicator(
          onRefresh: () async {
            context
                .read<PattientsDatesCubit>()
                .getPattientsDates(widget.userId);
          },
          child: dates.isEmpty
              ? const AppEmptyState(
                  icon: Icons.event_available_rounded,
                  title: 'Sin citas programadas',
                  message: 'Cuando tus pacientes agenden citas, aparecerán aquí.',
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  child: ListView(
                    children: itemsList(
                      context,
                      dates,
                      widget.onItemTap,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

List<Widget> itemsList(
    BuildContext context, List<DateModel> dates, Function onTap) {
  final List<Widget> list = [];

  list.add(const SizedBox(height: AppSpacing.sm));
  for (final DateModel date in dates) {
    list.add(GestureDetector(
      onTap: () {
        onTap(date);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.md),
                  topRight: Radius.circular(AppRadius.md),
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded,
                          color: Theme.of(context).colorScheme.onPrimary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                          date != null ? getDateFormatWithText(date.date!) : "",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.schedule_rounded,
                          color: Theme.of(context).colorScheme.onPrimary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                          date != null ? getTimeFormatWithText(date.hour!) : "",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                    ],
                  )),
                ],
              ),
            ),
            containerItem(
                context,
                Colors.white,
                date != null ? "${date.patient!.name}" : "",
                date != null ? "${date.patient!.email}" : '',
                "", () {
              onTap(date);
            }, hasHeader: true, icon: Icons.info_outline_rounded),
          ],
        ),
      ),
    ));

    list.add(const SizedBox(height: AppSpacing.sm));
  }
  return list;
}
