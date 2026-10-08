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
            return AppErrorState(
              message: 'No pudimos cargar tu diario. Inténtalo de nuevo.',
              onRetry: () =>
                  context.read<DailyCubit>().getNotes(widget.patientModel.id!),
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
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md),
                          ),
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
                          child: const Text('Progreso')),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                  ),
            body: state.result == DailyResult.loading
                ? Center(
                    child: Lottie.asset(Assets.brainLoading),
                  )
                : notes.isEmpty
                    ? const AppEmptyState(
                        icon: Icons.auto_stories_rounded,
                        title: 'Tu diario está vacío',
                        message:
                            'Este es tu diario personal, aquí podrás escribir tus pensamientos y emociones.\n\n¡Comienza a escribir!',
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
                        borderRadius: BorderRadius.circular(AppRadius.pill)),
                    elevation: 4,
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
                    child: Icon(
                      Icons.edit_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
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
      final scheme = Theme.of(context).colorScheme;
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(achivement.name!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: AppColors.shadowWarm)),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Text(achivement.description!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.shadowWarm)),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Text('¡Nuevo logro desbloqueado!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: scheme.primary)),
                ),
                const SizedBox(height: AppSpacing.sm),
                demoSvg(
                  achivement.imageUrl!,
                  width: MediaQuery.of(context).size.width * 0.3,
                  fit: BoxFit.cover,
                  placeholderBuilder: (context) => const AppLoadingIndicator(),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Recoger logro',
                  onPressed: () async {
                    final UICubit uiProvider = getIt<UICubit>();

                    uiProvider.addAchivementToUser(achivement);

                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
