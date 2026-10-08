import 'dart:async';
import '../../../helpers/paths.dart';

enum ItemUiType { colores, fondo, jardin, flores }

class CustomMenuScreen extends StatefulWidget {
  final BegginCubit userProvider;
  final UICubit uiProvider;
  const CustomMenuScreen(
      {super.key, required this.userProvider, required this.uiProvider});

  @override
  State<CustomMenuScreen> createState() => _CustomMenuScreenState();
}

class _CustomMenuScreenState extends State<CustomMenuScreen>
    with SingleTickerProviderStateMixin {
  late BegginCubit userProvider;
  bool animatedMenu = false;
  AnimationController? _animationController;
  Animation<Color?>? _animation;
  bool _isControllerDisposed = false;

  StreamSubscription? _cubitSubscription;

  @override
  void initState() {
    super.initState();
    userProvider = widget.userProvider;
    animatedMenu = animatedMenuBools[
            userProvider.state.registerPatientFlow ?? "registerSuccess"] ??
        false;

    if (animatedMenu) {
      _createAnimationController();
    }

    _cubitSubscription = userProvider.stream.listen((state) {
      if (!mounted) return;

      setState(() {
        animatedMenu =
            animatedMenuBools[state.registerPatientFlow ?? "registerSuccess"]!;
        if (animatedMenu) {
          _disposeAnimationController();
          _createAnimationController();
        } else {
          _disposeAnimationController();
        }
      });
    });
  }

  void _createAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = ColorTween(
      begin: AppColors.daySecondary,
      end: AppColors.dayTertiary,
    ).animate(_animationController!);

    if (WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations) {
      _animationController!.value = 1;
    } else {
      _animationController!.repeat(reverse: true);
    }
  }

  void _disposeAnimationController() {
    if (_isControllerDisposed) return;

    _animationController?.dispose();
    _isControllerDisposed = true;
  }

  @override
  void dispose() {
    _cubitSubscription?.cancel();
    _disposeAnimationController();
    super.dispose();
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
        child: ListView(
          children: [
            listItemCustom(
                context,
                "Paleta de colores",
                const AssetImage(
                  Assets.colorPallete,
                ), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeUiItemScreen(
                    userProvider: widget.userProvider,
                    uiProvider: widget.uiProvider,
                    itemType: ItemUiType.colores,
                    items: [
                      widget.uiProvider.state.themes[0],
                      // widget.uiProvider.state.themes[1],
                    ],
                    blocks: const [false, false, true, false],
                  ),
                ),
              );
            }, animatedMenu, false, _animationController, _animation),
            const SizedBox(height: AppSpacing.lg),
            listItemCustom(context, "Fondo de pantalla",
                const AssetImage(Assets.backPickerIcon), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeUiItemScreen(
                    userProvider: widget.userProvider,
                    uiProvider: widget.uiProvider,
                    itemType: ItemUiType.fondo,
                    items: const [
                      Assets.yardBackgroundLottieAnimation,
                      Assets.starBackgroundLottieAnimation,
                    ],
                    blocks: const [false, true, false, false],
                  ),
                ),
              );
            }, animatedMenu, false, _animationController, _animation),
            const SizedBox(height: AppSpacing.lg),
            listItemCustom(
                context,
                "Personalizar jardín",
                const AssetImage(
                  Assets.patioIcon,
                ), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          plane: null,
                          tap: () async {
                            final uiProvider = context.read<UICubit>();

                            if (uiProvider.state.currentFlower == null) {
                              await showMessageDialog(context, "",
                                  'Por favor debes elegir una planta para poder continuar, haz clic en la maceta para elegir una.');
                            }
                          },
                          registerFlow: userProvider.state.registerPatientFlow,
                          customEnable: true,
                        )),
              );
            }, false, animatedMenu, _animationController, _animation),
          ],
        ),
      ),
    );
  }
}

Widget listItemCustom(
  BuildContext context,
  String title,
  AssetImage icon,
  Function onTap,
  bool disable,
  bool animate,
  AnimationController? animationController,
  Animation<Color?>? animation,
) {
  return AppCard(
    onTap: disable ? null : () => onTap(),
    child: Row(
      children: [
        Expanded(
          child: disable == false && animate == true
              ? AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) => Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: animation!.value ?? AppColors.shadowWarm,
                        ),
                  ),
                )
              : Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: disable
                            ? AppColors.shadowWarm.withOpacity(0.4)
                            : AppColors.shadowWarm,
                      ),
                ),
        ),
        Image(
          image: icon,
          width: 40,
        ),
      ],
    ),
  );
}
