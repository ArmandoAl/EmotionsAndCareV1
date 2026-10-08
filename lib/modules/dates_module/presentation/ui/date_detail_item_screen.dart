import '../../../../helpers/paths.dart';
import '../../../../widgets/header_specialist_widget.dart';

class DateDetail extends StatefulWidget {
  final int speciaistId;
  final DateModel date;
  final SpecialistModel specialist;
  const DateDetail(
      {super.key,
      required this.date,
      required this.speciaistId,
      required this.specialist});

  @override
  State<DateDetail> createState() => _DateDetailState();
}

class _DateDetailState extends State<DateDetail> {
  bool isloading = false;
  bool aceptedLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSpecialistWidget(
        title: '',
        isForReturn: true,
        context: context,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      convertToName(widget.date.patient!.name!),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: AppColors.shadowWarm),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _infoRow(context, Icons.mail_rounded,
                        widget.date.patient!.email!),
                    const SizedBox(height: AppSpacing.xs),
                    _infoRow(context, Icons.phone_rounded,
                        widget.date.patient!.phone!,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppSpacing.xl),
                    Text("Información de la cita",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.shadowWarm)),
                    const SizedBox(height: AppSpacing.sm),
                    if (widget.date.date != null)
                      _infoRow(context, Icons.calendar_today_rounded,
                          getDateFormatWithText(widget.date.date!),
                          iconColor: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: AppSpacing.sm),
                    _infoRow(context, Icons.access_time_rounded,
                        getTimeFormatWithText(widget.date.hour!),
                        iconColor: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: AppSpacing.sm),
                    _infoRow(context, Icons.location_on_rounded,
                        widget.date.place!,
                        iconColor: Theme.of(context).colorScheme.primary),
                    Row(
                      children: [
                        const Spacer(),
                        AppButton.secondary(
                          label: "Editar",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DateDetailScreen(
                                        dateModel: widget.date,
                                        isPattient: false,
                                        especialistaModel: widget.specialist,
                                        patientModel: widget.date.patient!,
                                        edit: true)));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text("Descripción",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.shadowWarm)),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.date.description!,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                      ),
                    ),
                  ],
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
                          title: 'Rechazar cita',
                          message:
                              '¿Estás seguro de que quieres rechazar esta cita? El paciente será notificado.',
                          confirmLabel: 'Rechazar',
                          isDestructive: true,
                        );
                        if (!confirmed || !context.mounted) return;

                        setState(() {
                          isloading = true;
                        });

                        await context.read<PattientsDatesCubit>().rejectDate(
                              widget.speciaistId,
                              widget.date.id!,
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
                            .read<PattientsDatesCubit>()
                            .aceptDateBySpecialist(
                                widget.speciaistId, widget.date.id!);

                        if (res && context.mounted) {
                          await context
                              .read<ScheduleCubit>()
                              .getDatesForSpecialist(widget.speciaistId);
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
      ),
    );
  }
}

String getDateFormatWithText(DateTime date) {
  //formato 19 feb 2025
  final String day = date.day.toString();

  switch (date.month) {
    case 1:
      return '$day Ene ${date.year}';
    case 2:
      return '$day Feb ${date.year}';
    case 3:
      return '$day Mar ${date.year}';
    case 4:
      return '$day Abr ${date.year}';
    case 5:
      return '$day May ${date.year}';
    case 6:
      return '$day Jun ${date.year}';
    case 7:
      return '$day Jul ${date.year}';
    case 8:
      return '$day Ago ${date.year}';
    case 9:
      return '$day Sep ${date.year}';
    case 10:
      return '$day Oct ${date.year}';
    case 11:
      return '$day Nov ${date.year}';
    case 12:
      return '$day Dic ${date.year}';
    default:
      return '';
  }
}

String getTimeFormatWithText(String hour) {
  //input 18:0,
  //take the first number (18) and give an output like 6:00 PM

  final List<String> hourList = hour.split(':');
  final int hourInt = int.parse(hourList[0]);

  //si el numero termina asi: 6:0 PM vuelvelo asi 6:00 PM
  if (hourList[1].length == 1) {
    return '${hourInt > 12 ? hourInt - 12 : hourInt}:0${hourList[1]} ${hourInt > 12 ? 'PM' : 'AM'}';
  }

  return '${hourInt > 12 ? hourInt - 12 : hourInt}:${hourList[1]} ${hourInt > 12 ? 'PM' : 'AM'}';
}

String convertToName(String name) {
  //input: "juan perez"
  //output: "Juan Perez"
  final List<String> nameList = name.split(' ');
  String nameString = '';

  for (final String item in nameList) {
    nameString += '${item[0].toUpperCase()}${item.substring(1).toLowerCase()} ';
  }

  return nameString;
}

Widget _infoRow(BuildContext context, IconData icon, String text,
    {Color? iconColor, TextOverflow? overflow}) {
  return Row(
    children: [
      Icon(icon, color: iconColor ?? AppColors.shadowWarm),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Text(
          text,
          overflow: overflow,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.shadowWarm),
        ),
      ),
    ],
  );
}
