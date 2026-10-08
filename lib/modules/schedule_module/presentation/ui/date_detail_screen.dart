import '../../../../helpers/paths.dart';

class DateDetailScreen extends StatefulWidget {
  final DateModel? dateModel;
  final bool isPattient;
  final SpecialistModel? especialistaModel;
  final PatientModel? patientModel;
  final bool? edit;
  const DateDetailScreen({
    super.key,
    required this.dateModel,
    required this.isPattient,
    required this.especialistaModel,
    required this.patientModel,
    this.edit = false,
  });

  @override
  State<DateDetailScreen> createState() => _DateDetailScreenState();
}

class _DateDetailScreenState extends State<DateDetailScreen> {
  bool isEditing = false;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController specialistNotesController = TextEditingController();
  DateTime date = DateTime.now().toLocal();
  String hour = "";
  bool pendingToMatch = false;
  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
      value: "Inicial",
      child: Text("Inicial"),
    ),
    const DropdownMenuItem(
      value: "Completada",
      child: Text("Completada"),
    ),
    const DropdownMenuItem(
      value: "No completada",
      child: Text("No asistió"),
    ),
  ];
  String statusValue = "Inicial";

  @override
  void initState() {
    super.initState();

    descriptionController.text = widget.dateModel!.description ?? '';
    date = widget.dateModel!.date!;
    placeController.text = widget.dateModel!.place ?? '';
    hour = widget.dateModel!.hour!;
    statusValue = getStatusFromDateValue(widget.dateModel!.status!, items);
    if (widget.dateModel!.status == DateStatus.pendingToMatch) {
      pendingToMatch = true;
    }

    if (widget.edit == true) {
      isEditing = true;
    }
  }

  String getStatusFromDateValue(
      DateStatus status, List<DropdownMenuItem<String>> items) {
    switch (status) {
      case DateStatus.initial:
        return items[0].value!;
      case DateStatus.confirmed:
        return items[0].value!;
      case DateStatus.completed:
        return items[2].value!;
      case DateStatus.notCompleted:
        return items[3].value!;
      case DateStatus.pendingToMatch:
        return items[0].value!;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    placeController.dispose();
    specialistNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderWidget(
          title: "",
          isForReturn: true,
          actions: [
            if (isEditing)
              IconButton(
                  onPressed: () async {
                    setState(() {
                      isEditing = false;
                    });
                    //reset the values
                    descriptionController.text = widget.dateModel!.description!;
                    placeController.text = widget.dateModel!.place!;
                    specialistNotesController.text =
                        widget.dateModel!.specialistNotes!;
                    date = widget.dateModel!.date!;
                    hour = widget.dateModel!.hour!;
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                  )),
            IconButton(
                onPressed: () async {
                  await showDeleteMassageDialog(context, () async {
                    await showLoadingdialog("Eliminando cita", context,
                        () async {
                      await context
                          .read<ScheduleCubit>()
                          .deleteDate(widget.dateModel!.id!);
                    });

                    if (widget.isPattient == false && context.mounted) {
                      await context
                          .read<ScheduleCubit>()
                          .getDatesForSpecialist(widget.especialistaModel!.id!);
                    }
                  });

                  if (context.mounted) Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                )),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.isPattient == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            convertToName(widget.dateModel!.patient!.name!),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppColors.shadowWarm),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            "Cita",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.shadowWarm),
                          ),
                          _detailRow(
                              context,
                              Icons.calendar_month_rounded,
                              "${widget.dateModel!.date!.day}/${widget.dateModel!.date!.month}/${widget.dateModel!.date!.year}"),
                          _detailRow(context, Icons.access_time_rounded,
                              getTimeFormatWithText(widget.dateModel!.hour!)),
                          _detailRow(context, Icons.location_on_rounded,
                              widget.dateModel!.place!),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Datos del especialista",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: AppColors.shadowWarm)),
                              _detailRow(context, Icons.person_rounded,
                                  widget.patientModel!.specialist!.name!),
                              _detailRow(context, Icons.phone_rounded,
                                  widget.patientModel!.specialist!.phone!),
                              _detailRow(context, Icons.email_rounded,
                                  widget.patientModel!.specialist!.email!),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: AppSpacing.lg),
                GestureDetector(
                  onTap: () async {
                    if (isEditing) {
                      await showTableCaledarBottomSheet(
                        context: context,
                        initialDate: date,
                        onDaySelected: (DateTime selectedDay) {
                          setState(() {
                            date = selectedDay;
                          });
                        },
                      );
                    }
                  },
                  child: _fieldContainer(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(context, Icons.calendar_month_rounded, "Fecha"),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          getDateFormatWithText(date),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isEditing
                                    ? AppColors.shadowWarm
                                    : AppColors.shadowWarm.withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: () async {
                    if (isEditing) {
                      await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(date),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            hour = "${value.hour}:${value.minute}";
                          });
                        }
                      });
                    }
                  },
                  child: _fieldContainer(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(context, Icons.schedule_rounded, "Hora"),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          getTimeFormatWithText(hour),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isEditing
                                    ? AppColors.shadowWarm
                                    : AppColors.shadowWarm.withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _fieldContainer(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel(context, Icons.location_on_rounded, "Ubicación"),
                      TextField(
                        controller: placeController,
                        enabled: isEditing,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.shadowWarm),
                        decoration: const InputDecoration(
                          hintText: "Ej: Calle 123, CDMX",
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text("Descripción",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.shadowWarm)),
                const SizedBox(height: AppSpacing.xs),
                _fieldContainer(
                  context,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: TextField(
                    controller: descriptionController,
                    enabled: isEditing,
                    maxLines: null,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.shadowWarm),
                    decoration: const InputDecoration(
                      hintText: "Descripción",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (widget.isPattient == false) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    "Notas del especialista:",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.shadowWarm),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _fieldContainer(
                    context,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: TextField(
                      controller: specialistNotesController,
                      enabled: isEditing,
                      maxLines: null,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.shadowWarm),
                      decoration: const InputDecoration(
                        hintText: "Notas",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    "Estado de la cita:",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.shadowWarm),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _fieldContainer(
                    context,
                    child: DropdownButton(
                        // enable: isEditing,
                        underline: const SizedBox.shrink(),
                        elevation: 1,
                        isExpanded: true,
                        items: items,
                        onChanged: (value) {
                          setState(() {
                            statusValue = value.toString();
                          });
                        },
                        value: statusValue),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                if (widget.isPattient == true &&
                    widget.dateModel!.status == DateStatus.pendingToMatch &&
                    isEditing == false &&
                    widget.dateModel!.confirmByPatient == false &&
                    widget.dateModel!.confirmByEspetialist == true)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Text(
                        "El especialista ha hecho cambios en la cita, por favor acepta la cita o da click en editar para proponer una nueva fecha",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.shadowWarm,
                            )),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppButton.secondary(
                        label: isEditing ? "Guardar" : "Editar",
                        onPressed: () async {
                          if (isEditing) {
                            await showLoadingdialog("Guardando cita", context,
                                () async {
                              if (statusValue == "Inicial") {
                                bool res = await context
                                    .read<ScheduleCubit>()
                                    .updateDate(
                                      widget.dateModel!.copyWith(
                                        date: date,
                                        hour: hour,
                                        place: placeController.text,
                                        description: descriptionController.text,
                                        status: statusValue == "Inicial"
                                            ? DateStatus.pendingToMatch
                                            : statusValue == "Completada"
                                                ? DateStatus.completed
                                                : DateStatus.notCompleted,
                                        specialistNotes:
                                            specialistNotesController.text,
                                        confirmByEspetialist:
                                            !widget.isPattient,
                                        confirmByPatient: widget.isPattient,
                                        sentBySpecialist: !widget.isPattient,
                                      ),
                                      widget.dateModel!.patient!.id!,
                                      widget.especialistaModel!.id!,
                                      widget.isPattient,
                                    );

                                if (res == true && context.mounted) {
                                  showMessageDialog(context, "Cita actualizada",
                                      "Tu cita ha sido actualizada correctamente");
                                } else {
                                  if (context.mounted) {
                                    showMessageDialog(context, "Error",
                                        "Hubo un error al actualizar la cita",
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Aceptar"),
                                          ),
                                        ]);
                                  }
                                }

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                bool res = await context
                                    .read<ScheduleCubit>()
                                    .updateDateStatus(
                                      widget.dateModel!.copyWith(
                                        date: date,
                                        hour: hour,
                                        place: placeController.text,
                                        description: descriptionController.text,
                                        status: statusValue == "Inicial"
                                            ? DateStatus.pendingToMatch
                                            : statusValue == "Completada"
                                                ? DateStatus.completed
                                                : DateStatus.notCompleted,
                                        specialistNotes:
                                            specialistNotesController.text,
                                        sentBySpecialist: !widget.isPattient,
                                      ),
                                    );

                                if (res == true && context.mounted) {
                                  showMessageDialog(context, "Cita actualizada",
                                      "Tu cita ha sido actualizada correctamente");
                                } else {
                                  if (context.mounted) {
                                    showMessageDialog(context, "Error",
                                        "Hubo un error al actualizar la cita",
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Aceptar"),
                                          ),
                                        ]);
                                  }
                                }

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }

                              if (context.mounted) Navigator.of(context).pop();
                              if (context.mounted) Navigator.of(context).pop();
                            });
                          } else {
                            setState(() {
                              isEditing = !isEditing;
                            });
                          }
                        }),
                    if (widget.isPattient == true &&
                        widget.dateModel!.status == DateStatus.pendingToMatch &&
                        isEditing == false &&
                        widget.dateModel!.confirmByPatient == false &&
                        widget.dateModel!.confirmByEspetialist == true)
                      AppButton(
                          label: "Aceptar",
                          onPressed: () async {
                            await showLoadingdialog("Guardando cita", context,
                                () async {
                              await context
                                  .read<ScheduleCubit>()
                                  .confirmDateByPatient(
                                    widget.dateModel!.copyWith(
                                      status: DateStatus.confirmed,
                                    ),
                                    widget.dateModel!.patient!.id!,
                                  );

                              if (context.mounted) Navigator.of(context).pop();
                              if (context.mounted) Navigator.of(context).pop();
                            });
                          }),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ));
  }
}

Future<void> showDeleteMassageDialog(
    BuildContext context, Function() deleteFunction) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text("¿Estás seguro de que quieres eliminar esta cita?",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        actions: [
          AppButton.text(
            label: "Cancelar",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          AppButton.destructive(
            label: "Eliminar",
            onPressed: () async {
              await deleteFunction();
              if (context.mounted) Navigator.of(context).pop();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget _detailRow(BuildContext context, IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xs),
    child: Row(
      children: [
        Icon(icon, color: AppColors.shadowWarm.withOpacity(0.6), size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.shadowWarm),
          ),
        ),
      ],
    ),
  );
}

Widget _fieldLabel(BuildContext context, IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
      const SizedBox(width: AppSpacing.sm),
      Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: AppColors.shadowWarm),
      ),
    ],
  );
}

Widget _fieldContainer(
  BuildContext context, {
  required Widget child,
  EdgeInsetsGeometry padding =
      const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(color: AppColors.shadowWarm.withOpacity(0.2)),
    ),
    padding: padding,
    child: child,
  );
}
