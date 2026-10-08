import '../helpers/paths.dart';

class HeaderSpecialistWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final bool isForReturn;
  final List<Widget>? actions;
  final BuildContext context;
  const HeaderSpecialistWidget({
    super.key,
    required this.title,
    required this.isForReturn,
    this.actions,
    required this.context,
  });

  @override
  State<HeaderSpecialistWidget> createState() => _HeaderSpecialistWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(84);
}

class _HeaderSpecialistWidgetState extends State<HeaderSpecialistWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: AppShadows.soft,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.sm),
          bottomRight: Radius.circular(AppRadius.sm),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                const SizedBox(width: AppSpacing.sm),
                widget.isForReturn
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_rounded, color: scheme.onSurface),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    : const SizedBox(width: AppSpacing.xl),
                const Spacer(),
                if (widget.actions != null) Row(children: widget.actions!),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
      ),
    );
  }
}
