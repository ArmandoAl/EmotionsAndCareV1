import '../../../../demo/widgets/demo_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../helpers/paths.dart';

class DailyController extends StatefulWidget {
  final PatientModel patientModel;
  final Function(int)? changeIndex;
  final bool isPattient;
  const DailyController(
      {super.key,
      required this.patientModel,
      required this.changeIndex,
      required this.isPattient});

  @override
  State<DailyController> createState() => _DailyControllerState();
}

class _DailyControllerState extends State<DailyController> {
  late final DailyCubit dailyCubit;
  late final EmotionCubit emotionCubit;

  @override
  void initState() {
    dailyCubit = getIt<DailyCubit>();
    emotionCubit = getIt<EmotionCubit>();

    if (emotionCubit.state.emotions.isEmpty) {
      emotionCubit.getEmotions();
    }

    if (dailyCubit.state.notes.isEmpty) {
      dailyCubit.getNotes(widget.patientModel.id!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyCubit, DailyState>(
        bloc: context.read<DailyCubit>(),
        builder: (context, state) {
          if (state.result == DailyResult.error) {
            return const Center(
              child: Text('Error',
                  style: TextStyle(
                      color: Colors.red, decoration: TextDecoration.none)),
            );
          }

          final notes = widget.isPattient
              ? state.notes
              : state.notes
                  .where((element) => element.visible == true)
                  .toList();

          return Scaffold(
            appBar: widget.isPattient
                ? null
                : HeaderWidget(
                    title: "Diario de ${widget.patientModel.name}",
                    isForReturn: true,
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            if (dailyCubit.state.result ==
                                DailyResult.loading) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Cargando notas, intente de nuevo'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            if (dailyCubit.state.notes.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No hay notas para mostrar'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NotesProgressScreen(
                                    isPattient: widget.isPattient,
                                    notes: dailyCubit.state.notes,
                                    patientModel: widget.patientModel)));
                          },
                          child: const Text('Progreso',
                              style: TextStyle(color: Colors.white))),
                      const SizedBox(width: 5),
                    ],
                  ),
            body: state.result == DailyResult.loading
                ? Center(
                    child: Lottie.asset(Assets.brainLoading),
                  )
                : notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              'Este es tu diario personal, aquí podrás escribir tus pensamientos y emociones. \n\n ¡Comienza a escribir!',
                              style: TextStyle(
                                fontFamily:
                                    'Gilroy', // Usa la fuente personalizada
                                fontWeight: FontWeight.bold, // Gilroy-Medium
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ],
                        ),
                      )
                    : DailyScreen(
                        notes: notes,
                        onNoteTap: (note) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailScreen(note: note)));
                        },
                        onLongTap: (NoteModel note) {
                          context.read<DailyCubit>().remove(note);
                        },
                        reload: () async {
                          await context
                              .read<DailyCubit>()
                              .getNotes(widget.patientModel.id!);
                        },
                      ),
            floatingActionButton: widget.isPattient
                ? FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    elevation: 10,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NewNoteScreen(
                              id: widget.patientModel.id!,
                              patientModel: widget.patientModel,
                              onNoteCreated: (NoteModel note, id) async {
                                NoteWithAchivement res = await context
                                    .read<DailyCubit>()
                                    .addNote(note, id);

                                if (res.achivementId != null &&
                                    context.mounted) {
                                  final UICubit uiProvider =
                                      Provider.of<UICubit>(context,
                                          listen: false);

                                  final Achievement? achievement = uiProvider
                                      .getAchivement(res.achivementId!);

                                  if (achievement != null && context.mounted) {
                                    await showStickerDialog(
                                        context, achievement);
                                  }
                                }
                              },
                              onVisible: (visible) {
                                context
                                    .read<DailyCubit>()
                                    .changeVisibility(visible);
                              } //onVisible
                              )));
                    },
                    child: const Icon(
                      Icons.border_color_outlined,
                      color: Colors.white,
                    ),
                  )
                : null,
          );
        });
  }
}

Future<void> showStickerDialog(
    BuildContext context, Achievement achivement) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        backgroundColor: Colors.grey.withOpacity(0.85),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(achivement.name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(achivement.description!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('¡Nuevo logro desbloqueado!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.028,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                demoSvg(
                  achivement.imageUrl!,
                  width: MediaQuery.of(context).size.width * 0.3,
                  fit: BoxFit.cover,
                  placeholderBuilder: (context) =>
                      const CircularProgressIndicator(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1C8AAD),
                  ),
                  onPressed: () async {
                    final UICubit uiProvider = getIt<UICubit>();

                    uiProvider.addAchivementToUser(achivement);

                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: const Text('Recoger logro',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
