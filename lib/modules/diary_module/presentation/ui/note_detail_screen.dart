import '../../../../helpers/paths.dart';

class NoteDetailScreen extends StatelessWidget {
  final NoteModel note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final Color tint = emotionColors[note.emotion.name]!.withOpacity(0.12);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tint,
        title: Text(
            'Fecha: ${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: tint),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.shadowWarm,
                        ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(note.emotion.icon!, style: const TextStyle(fontSize: 30)),
              ],
            ),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.shadowWarm,
                      ),
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  note.visible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  size: 18,
                  color: AppColors.shadowWarm.withOpacity(0.7),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  "Visible para especialista: ${note.visible ? 'Sí' : 'No'}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.shadowWarm.withOpacity(0.7),
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
