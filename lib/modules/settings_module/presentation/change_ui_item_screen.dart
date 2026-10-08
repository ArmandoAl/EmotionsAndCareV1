import 'package:lottie/lottie.dart';
import '../../../helpers/paths.dart';

class ChangeUiItemScreen extends StatefulWidget {
  final BegginCubit userProvider;
  final UICubit uiProvider;
  final ItemUiType itemType;
  final List<dynamic> items;
  final List<bool> blocks;
  const ChangeUiItemScreen(
      {super.key,
      required this.userProvider,
      required this.uiProvider,
      required this.itemType,
      required this.items,
      required this.blocks});

  @override
  State<ChangeUiItemScreen> createState() => _ChangeUiItemScreenState();
}

class _ChangeUiItemScreenState extends State<ChangeUiItemScreen> {
  dynamic selectedItem;
  int selectedTheme = 0;

  @override
  void initState() {
    super.initState();
    if (widget.itemType == ItemUiType.colores) {
      selectedItem = widget.items[widget.uiProvider.state.selectedTheme];
      selectedTheme = widget.uiProvider.state.selectedTheme;
    } else {
      if (widget.itemType == ItemUiType.fondo) {
        selectedItem = widget.uiProvider.state.selectedBackground;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Personalización'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Text(
                widget.itemType == ItemUiType.colores
                    ? 'Selecciona una paleta de colores para tu aplicación'
                    : widget.itemType == ItemUiType.fondo
                        ? 'Selecciona un fondo de pantalla para tu jardín'
                        : widget.itemType == ItemUiType.jardin
                            ? 'Jardín'
                            : 'Flores',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.shadowWarm),
              ),
              Expanded(
                child: widget.itemType == ItemUiType.colores
                    ? ListView.builder(
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedItem = widget.items[index];
                                selectedTheme = index;
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                margin: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                  border: Border.all(
                                    color: selectedTheme == index
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: selectedTheme == index
                                      ? AppShadows.card
                                      : AppShadows.none,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      color: widget.items[index].primaryColor,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      color: widget
                                          .items[index].colorScheme.primary,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      color: widget
                                          .items[index].colorScheme.secondary,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      color: widget
                                          .items[index].colorScheme.surface,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      color: widget
                                          .items[index].colorScheme.background,
                                    ),
                                  ],
                                )),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: widget.items.length + 1,
                        itemBuilder: (context, index) {
                          if (index == widget.items.length) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSpacing.sm),
                                    child: AppButton(
                                      variant: selectedItem == "null"
                                          ? AppButtonVariant.primary
                                          : AppButtonVariant.secondary,
                                      label: 'Color por defecto',
                                      onPressed: () {
                                        setState(() {
                                          selectedItem = "null";
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedItem = widget.items[index];
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.65,
                              margin: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: selectedItem == widget.items[index]
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: selectedItem == widget.items[index]
                                    ? AppShadows.card
                                    : AppShadows.none,
                              ),
                              child: Lottie.asset(
                                widget.items[index],
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: selectedItem != null
            ? FloatingActionButton(
                onPressed: () {
                  if (widget.itemType == ItemUiType.colores) {
                    widget.uiProvider.setTheme(
                        widget.userProvider.state.patientModel!.id!,
                        selectedTheme);

                    Navigator.pop(context);
                  } else if (widget.itemType == ItemUiType.fondo) {
                    final index = widget.items.indexOf(selectedItem);
                    widget.uiProvider.setSelectedBackground(
                      widget.userProvider.state.patientModel!.id!,
                      selectedItem,
                      index,
                    );
                    Navigator.pop(context);
                  } else {
                    // widget.uiProvider.changeFlower(selectedItem);
                  }
                },
                child: const Icon(Icons.check_rounded),
              )
            : null);
  }
}

Future<void> showDialogForAds(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(''),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
