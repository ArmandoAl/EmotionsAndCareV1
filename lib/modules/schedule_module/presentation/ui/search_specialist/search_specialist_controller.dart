import '../../../../../helpers/paths.dart';

class SearchSpecialistController extends StatefulWidget {
  final PatientModel? patientModel;
  const SearchSpecialistController({super.key, required this.patientModel});

  @override
  State<SearchSpecialistController> createState() =>
      _SearchSpecialistControllerState();
}

class _SearchSpecialistControllerState
    extends State<SearchSpecialistController> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ScheduleCubit>();
    if (context.read<ScheduleCubit>().state.specialists.isEmpty) {
      context.read<ScheduleCubit>().getSpecialists();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Buscar especialista"),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                onPressed: () {
                  showMessageDialog(context, "Informacion",
                      "En este apartado se encuentra el catálogo de especialistas con los que te puedes vincular. |También puedes pedirle el código de vinculación a cualquier especialista de tu preferencia para agregarlo manualmente.");
                },
              ),
            ],
          ),
          body: SearchSpecialistScreen(
            patientModel: widget.patientModel,
            controller: controller,
            searchController: searchController,
            searchFunction: (value) {
              context.read<ScheduleCubit>().searchSpecialisInTime(value);
            },
            specislist: state.specialists,
            onTapSpecialist: (specialist) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SpecialistDetailScreen(
                    patientModel: widget.patientModel,
                    specialistModel: specialist,
                    syncByCode: (code) async {
                      final res = await context
                          .read<BegginCubit>()
                          .syncByCode(widget.patientModel!.id!, code);

                      return res;
                    },
                  ),
                ),
              );
            },
            onFilterTap: () async {
              await showFilterialog(context);
            },
            syncDirectByCode: (code) async {
              final res = await context
                  .read<BegginCubit>()
                  .syncByDirectCode(widget.patientModel!.id!, code);

              if (res && context.mounted) {
                context
                    .read<BegginCubit>()
                    .reloginPatient(widget.patientModel!);
              }

              return res;
            },
            syncByCode: (code) async {
              final res = await context
                  .read<BegginCubit>()
                  .syncByCode(widget.patientModel!.id!, code);

              return res;
            },
          ),
        );
      },
    );
  }
}

Future<void> showFilterialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          final filers = state.filters;

          return AlertDialog(
            title: const Text("Filtrar especialistas"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text("Sexo: "),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: filers["sexo"] ?? "Sin especificar",
                        items: const [
                          DropdownMenuItem(
                            value: "Sin especificar",
                            child: Text("Sin especificar"),
                          ),
                          DropdownMenuItem(
                            value: "Masculino",
                            child: Text("Masculino"),
                          ),
                          DropdownMenuItem(
                            value: "Femenino",
                            child: Text("Femenino"),
                          ),
                        ],
                        onChanged: (value) {
                          context.read<ScheduleCubit>().addFilter(
                                "sexo",
                                value,
                              );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Edad: "),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: filers["edad"] ?? "Sin especificar",
                        items: const [
                          DropdownMenuItem(
                            value: "Sin especificar",
                            child: Text("Sin especificar"),
                          ),
                          DropdownMenuItem(
                            value: "20-30",
                            child: Text("20-30"),
                          ),
                          DropdownMenuItem(
                            value: "30-45",
                            child: Text("30-45"),
                          ),
                          DropdownMenuItem(
                            value: "45-100",
                            child: Text("45+"),
                          ),
                        ],
                        onChanged: (value) {
                          context.read<ScheduleCubit>().addFilter(
                                "edad",
                                value,
                              );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Especialidad: "),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: filers["especialidad"] ?? "Sin especificar",
                        items: const [
                          DropdownMenuItem(
                            value: "Sin especificar",
                            child: Text("Sin especificar"),
                          ),
                          DropdownMenuItem(
                            value: "Cognitivo-Conductual",
                            child: Text("Cognitivo-Conductual"),
                          ),
                          DropdownMenuItem(
                            value: "Psicoanálisis",
                            child: Text("Psicoanálisis"),
                          ),
                          DropdownMenuItem(
                            value: "Humanista",
                            child: Text("Humanista"),
                          ),
                          DropdownMenuItem(
                            value: "Sistémico",
                            child: Text("Sistémico"),
                          ),
                          DropdownMenuItem(
                            value: "Neuropsicológico",
                            child: Text("Neuropsicológico"),
                          ),
                          DropdownMenuItem(
                            value: "Gestalt",
                            child: Text("Gestalt"),
                          ),
                          DropdownMenuItem(
                            value: "Sexología",
                            child: Text("Sexología"),
                          ),
                        ],
                        onChanged: (value) {
                          context.read<ScheduleCubit>().addFilter(
                                "especialidad",
                                value,
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              AppButton.text(
                label: "Salir",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              AppButton.text(
                label: "Limpiar",
                onPressed: () {
                  context.read<ScheduleCubit>().clearFilters();
                  Navigator.of(context).pop();
                },
              ),
              AppButton(
                label: "Filtrar",
                onPressed: () {
                  context.read<ScheduleCubit>().filterSpecialist(state.filters);

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}
