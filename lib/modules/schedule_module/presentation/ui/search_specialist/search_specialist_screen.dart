import '../../../../../helpers/paths.dart';

class SearchSpecialistScreen extends StatefulWidget {
  final PatientModel? patientModel;
  final TextEditingController controller;
  final TextEditingController searchController;
  final Function(String) searchFunction;
  final List<SpecialistModel> specislist;
  final Function(SpecialistModel) onTapSpecialist;
  final Function onFilterTap;
  final Future<bool> Function(String) syncByCode;
  final Future<bool> Function(String) syncDirectByCode;
  //syncDirectByCode
  const SearchSpecialistScreen(
      {super.key,
      required this.patientModel,
      required this.controller,
      required this.searchController,
      required this.specislist,
      required this.onTapSpecialist,
      required this.onFilterTap,
      required this.searchFunction,
      required this.syncByCode,
      required this.syncDirectByCode});

  @override
  State<SearchSpecialistScreen> createState() => _SearchSpecialistScreenState();
}

class _SearchSpecialistScreenState extends State<SearchSpecialistScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.searchController,
                    decoration: const InputDecoration(
                      hintText: "Buscar especialista",
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                    onChanged: (value) {
                      widget.searchFunction(value);
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  onPressed: () {
                    widget.onFilterTap();
                  },
                  icon: const Icon(Icons.filter_list_rounded),
                ),
              ],
            ),
          ),
          Expanded(
              child: widget.specislist.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.person_search_rounded,
                      title: 'Sin resultados',
                      message:
                          'No encontramos especialistas con esos filtros. Intenta ajustar tu búsqueda.',
                    )
                  : ListView.builder(
                      itemCount: widget.specislist.length,
                      itemBuilder: (context, index) {
                        final bool isLinked = widget.patientModel!.specialist !=
                                null &&
                            widget.specislist[index].id ==
                                widget.patientModel!.specialist!.id;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                          child: AppCard(
                            color: isLinked
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            onTap: () {
                              widget.onTapSpecialist(widget.specislist[index]);
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    child: Icon(Icons.person_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.specislist[index].name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  color: AppColors.shadowWarm)),
                                      Text("Sexo: ${widget.specislist[index].sex}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: AppColors.shadowWarm
                                                      .withOpacity(0.7))),
                                      Text(
                                          "Edad: ${widget.specislist[index].age} años",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: AppColors.shadowWarm
                                                      .withOpacity(0.7))),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: AppColors.shadowWarm.withOpacity(0.5)),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
          const Divider(),
          requestByCodeWidget(
              context, widget.controller, widget.syncDirectByCode, isLoading,
              () {
            setState(() {
              isLoading = !isLoading;
            });
          }),
        ],
      ),
    );
  }
}

Widget requestByCodeWidget(
    BuildContext context,
    TextEditingController controller,
    Future<bool> Function(String) syncByCode,
    bool isLoading,
    Function changeLoadingState) {
  return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xs),
          Text("Vincular con código",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.shadowWarm)),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: TextField(
              controller: controller,
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Código",
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: "Vincular",
            isLoading: isLoading,
            onPressed: () async {
              changeLoadingState();
              bool result = await syncByCode(controller.text);
              changeLoadingState();
              if (result == true && context.mounted) {
                showConfirmialog(
                    context,
                    result
                        ? "Vinculación exitosa"
                        : "Código no existente encontrado");
              } else {
                if (context.mounted) {
                  showMessageDialog(context, "Error al vincular especialista",
                      "Por favor, verifica el código e intenta nuevamente");
                }
              }

              controller.clear();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ));
}

void showConfirmialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Vinculación",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        content: Text(message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.shadowWarm)),
        actions: [
          AppButton.text(
            label: "Aceptar",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
