import 'dart:async';

import '../../../../helpers/paths.dart';

class TestsScreen extends StatefulWidget {
  static const String route = 'tests';
  final List<TestModel> testList;
  final List<CompletedTestModel> completedTestList;
  final void Function(TestModel test) onTestTap;
  final Future<void> Function() onRefresh;
  const TestsScreen(
      {super.key,
      required this.testList,
      required this.completedTestList,
      required this.onTestTap,
      required this.onRefresh});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen>
    with SingleTickerProviderStateMixin {
  late BegginCubit userProvider;
  bool animatedMenu = true;
  bool _dialogShown = false; // Evitar mostrar el diálogo más de una vez
  AnimationController? _animationController;
  Animation? _animation;

  StreamSubscription? _cubitSubscription;

  @override
  void initState() {
    super.initState();
    userProvider = getIt<BegginCubit>();

    animatedMenu = animatedMenuBools[
        userProvider.state.registerPatientFlow ?? "registerSuccess"]!;

    final state = userProvider.state;

    if (state.registerPatientFlow == "register") {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );

      _animation = ColorTween(
        begin: AppColors.dayPrimaryContainer,
        end: AppColors.daySecondary.withOpacity(0.55),
      ).animate(_animationController!);

      if (WidgetsBinding
              .instance.platformDispatcher.accessibilityFeatures.disableAnimations) {
        _animationController!.value = 1;
      } else {
        _animationController!.repeat(reverse: true);
      }

      setState(() {});
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = userProvider.state;

      if (state.registerPatientFlow == "register") {
        await showMessageDialog(context, "Cuestionarios",
            "En esta sección, encontrarás instrumentos validados en México para evaluar indicadores de salud mental. |Es importante que respondas con honestidad.");
      }
    });
  }

  //didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubitSubscription?.cancel();
    _cubitSubscription = userProvider.stream.listen((state) {
      if (!mounted) return;

      if (state.registerPatientFlow! == "firstTestCompleted") {
        setState(() {
          _dialogShown = false;
        });
      }

      setState(() {
        animatedMenu =
            animatedMenuBools[state.registerPatientFlow ?? "registerSuccess"]!;
      });

      if (animatedMenu && !_dialogShown) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showMessageDialog(
              context,
              "Cuestionarios",
              state.registerPatientFlow! == "register"
                  ? "En esta sección, encontrarás instrumentos validados en México para evaluar indicadores de salud mental. |Es importante que respondas con honestidad."
                  : "Gracias por completar tu primer cuestionario. |Con base en tus respuestas, recibirás consejos para apoyarte en tu camino. |Por favor dirígete al menú.");
        });

        _dialogShown = true;
      }
    });
  }

  @override
  void dispose() {
    _cubitSubscription?.cancel();

    _animationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: RefreshIndicator(
            onRefresh: () async {
              await widget.onRefresh();
            },
            child: ListView.builder(
                itemCount: widget.testList.length,
                itemBuilder: (context, index) {
                  final item = widget.testList[index];
                  final bool isCompleted = widget.completedTestList
                      .any((element) => element.testId == item.id);
                  if (userProvider.state.registerPatientFlow == "register") {
                    return AnimatedBuilder(
                      animation: _animationController!,
                      builder: (context, child) {
                        return Container(
                            decoration: BoxDecoration(
                              color: _animation!.value,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              boxShadow: AppShadows.card,
                            ),
                            margin: const EdgeInsets.all(AppSpacing.sm),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: ListTestItems(
                              item: item,
                              completedTestList: widget.completedTestList,
                              onTestTap: widget.onTestTap,
                            ));
                      },
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.all(AppSpacing.sm),
                      child: AppCard(
                        color: isCompleted
                            ? scheme.surfaceContainerHighest
                            : scheme.primaryContainer,
                        padding: EdgeInsets.zero,
                        child: ListTestItems(
                          item: item,
                          completedTestList: widget.completedTestList,
                          onTestTap: widget.onTestTap,
                        ),
                      ),
                    );
                  }
                })));
  }
}

class ListTestItems extends StatefulWidget {
  final TestModel item;
  final List<CompletedTestModel> completedTestList;
  final void Function(TestModel test) onTestTap;
  const ListTestItems(
      {super.key,
      required this.item,
      required this.completedTestList,
      required this.onTestTap});

  @override
  State<ListTestItems> createState() => _ListTestItemsState();
}

class _ListTestItemsState extends State<ListTestItems> {
  @override
  Widget build(BuildContext context) {
    final bool isCompleted = widget.completedTestList
        .any((element) => element.testId == widget.item.id);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color foreground =
        isCompleted ? AppColors.shadowWarm.withOpacity(0.6) : AppColors.shadowWarm;

    return ListTile(
      title: Text(widget.item.name,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: foreground)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.item.questions.length} preguntas",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: foreground)),
          if (isCompleted)
            Text(
                "Completado ${widget.completedTestList.firstWhere((element) => element.testId == widget.item.id).date.day}/${widget.completedTestList.firstWhere((element) => element.testId == widget.item.id).date.month}/${widget.completedTestList.firstWhere((element) => element.testId == widget.item.id).date.year}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: foreground)),
        ],
      ),
      trailing: isCompleted
          ? Icon(Icons.check_circle_rounded, color: scheme.primary)
          : Icon(Icons.chevron_right_rounded, color: foreground),
      onTap: () {
        widget.onTestTap(widget.item);
      },
    );
  }
}
