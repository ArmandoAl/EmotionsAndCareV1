import '../../../../helpers/paths.dart';

class DailyScreen extends StatefulWidget {
  static const String route = 'daily';
  final List<NoteModel> notes;
  final void Function(NoteModel note) onNoteTap;
  final void Function(NoteModel note) onLongTap;
  final Future<void> Function() reload;
  const DailyScreen(
      {super.key,
      required this.notes,
      required this.onNoteTap,
      required this.onLongTap,
      required this.reload});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      child: RefreshIndicator(
        onRefresh: () async {
          await widget.reload();
        },
        child: ListView.builder(
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            final item = widget.notes[index];
            return GestureDetector(
              onTap: () {
                widget.onNoteTap(item);
              },
              onLongPress: () {
                _showRemoveNoteDialog(context, item, (note) {
                  widget.onLongTap(note);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: emotionColors[item.emotion.name]!.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppShadows.card,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.shadowWarm,
                                    )),
                            Text(
                              "${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.shadowWarm.withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(item.emotion.icon!, style: const TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(item.content,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.shadowWarm,
                            )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _showRemoveNoteDialog(
    BuildContext context, NoteModel note, Function(NoteModel note) onRemove) async {
  final bool confirmed = await showAppConfirmDialog(
    context,
    title: 'Eliminar nota',
    message: '¿Estás seguro de que quieres eliminar esta nota?',
    confirmLabel: 'Eliminar',
    isDestructive: true,
  );
  if (confirmed) {
    onRemove(note);
  }
}
