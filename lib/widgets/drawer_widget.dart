import 'package:emotions_and_care_v1/helpers/navigation_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/paths.dart';

class DrawerWidget extends StatefulWidget {
  final int currentIndex;
  final Function(int) changeIndex;
  final int? animatedIndex;
  final int? dynamicIndex;
  const DrawerWidget(
      {super.key,
      required this.currentIndex,
      required this.changeIndex,
      this.animatedIndex,
      this.dynamicIndex});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

const drawerDynaicIndexNumbers = {
  "register": 1,
  "firstTestCompleted": 5,
  "registerSuccess": -1,
};

class _NavigationItem {
  final NavigationItem item;
  final String title;
  final IconData icon;

  _NavigationItem(this.item, this.title, this.icon);
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation _animation;
  int? dinamicIndex;

  final List<_NavigationItem> _itemList = [
    _NavigationItem(NavigationItem.home, 'Jardín', Icons.eco_rounded),
    _NavigationItem(
        NavigationItem.test, 'Cuestionarios', Icons.assignment_rounded),
    _NavigationItem(NavigationItem.dairy, 'Diario', Icons.menu_book_rounded),
    _NavigationItem(
        NavigationItem.community, 'Comunidad', Icons.diversity_3_rounded),
    _NavigationItem(NavigationItem.schedule, 'Agenda', Icons.event_rounded),
    _NavigationItem(
        NavigationItem.goals, 'Colección', Icons.auto_awesome_rounded),
    _NavigationItem(
        NavigationItem.settings, 'Configuración', Icons.settings_rounded),
  ];

  @override
  void initState() {
    super.initState();
    final bool disableAnimations =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (!disableAnimations) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.value = 1;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    _animation = ColorTween(
      begin: scheme.secondary,
      end: scheme.primary,
    ).animate(_animationController);

    final registerFlow =
        context.watch<BegginCubit>().state.registerPatientFlow ??
            "registerSuccess";

    dinamicIndex = drawerDynaicIndexNumbers[registerFlow]!;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.local_florist_rounded, color: scheme.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text('Emotions & Care',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Divider(height: AppSpacing.lg),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: [
                  ..._itemList.map((item) {
                    return BlocBuilder<NavigationBloc, NavigationState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                          child: _menuItem(
                            context: context,
                            title: item.title,
                            icon: item.icon,
                            index: item.item.index,
                            currentIndex: widget.currentIndex,
                            dynamicIndex: dinamicIndex,
                            animationController: _animationController,
                            animation: _animation,
                            onTap: () {
                              if (item.item.index != widget.currentIndex) {
                                BlocProvider.of<NavigationBloc>(context).add(
                                  NavigateTo(item.item),
                                );
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    );
                  })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: OutlinedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Emergencia'),
                        content: const Text(
                            '¿Quieres llamar a la línea de emergencia?'),
                        actions: [
                          AppButton.text(
                            label: 'Cancelar',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          AppButton.destructive(
                            label: 'Llamar',
                            onPressed: () {
                              const String phoneNumber = '800-911-2000';
                              const String url = 'tel:$phoneNumber';
                              launchUrlString(url);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.support_agent_rounded, color: scheme.error),
                label: Text('Línea de emergencia',
                    style: TextStyle(color: scheme.error)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: scheme.error.withOpacity(0.4)),
                  foregroundColor: scheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _menuItem({
  required BuildContext context,
  required String title,
  required IconData icon,
  required int index,
  required int currentIndex,
  required int? dynamicIndex,
  required AnimationController animationController,
  required Animation animation,
  required VoidCallback onTap,
}) {
  final scheme = Theme.of(context).colorScheme;
  final bool isSelected = index == currentIndex;
  final bool isHighlighted = dynamicIndex! >= 0 && dynamicIndex == index;

  Widget tile({Color? iconColor, Color? textColor}) {
    return Material(
      color: isSelected ? scheme.primaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? (isSelected ? scheme.primary : scheme.onSurface), size: 22),
              const SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: textColor ?? (isSelected ? scheme.primary : scheme.onSurface),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  if (isHighlighted) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final Color color = animation.value ?? scheme.primary;
        return tile(iconColor: color, textColor: color);
      },
    );
  }

  return IgnorePointer(
    ignoring: dynamicIndex >= 0,
    child: Opacity(
      opacity: dynamicIndex >= 0 ? 0.4 : 1,
      child: tile(),
    ),
  );
}

Future<void> launchUrlString(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
