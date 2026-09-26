import 'dart:async';
import 'package:emotions_and_care_v1/helpers/paths.dart';

class HeaderWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isForReturn;
  final List<Widget>? actions;
  const HeaderWidget({
    super.key,
    required this.title,
    required this.isForReturn,
    this.actions,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _HeaderWidgetState extends State<HeaderWidget>
    with TickerProviderStateMixin {
  late BegginCubit begginCubit;
  AnimationController? _buttonController;
  Animation<Color?>? _buttonAnimation;
  String status = "";
  bool animatedMenu = false;
  bool _isControllerDisposed = false; // Nueva bandera para rastrear el estado
  StreamSubscription? _cubitSubscription;

  @override
  void initState() {
    super.initState();
    begginCubit = getIt<BegginCubit>();
    animatedMenu = animatedMenuBools[
            begginCubit.state.registerPatientFlow ?? "registerSuccess"] ??
        false;

    if (animatedMenu) {
      _createAnimationController();
    }

    // Escuchar el stream del cubit y almacenar la suscripción
    _cubitSubscription = begginCubit.stream.listen((state) {
      if (!mounted) return; // Verificar si el widget está montado

      setState(() {
        status = state.registerPatientFlow ?? "";
        animatedMenu = animatedMenuBools[status]!;

        if (animatedMenu) {
          _disposeAnimationController(); // Asegurarse de eliminar el anterior
          _createAnimationController();
        } else {
          _disposeAnimationController();
        }
      });
    });
  }

  void _createAnimationController() {
    _isControllerDisposed = false; // Restablecer bandera
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _buttonController!.value = 1;
    } else {
      _buttonController!.repeat(reverse: true);
    }

    final scheme = Theme.of(context).colorScheme;
    _buttonAnimation = ColorTween(
      begin: scheme.secondary,
      end: scheme.primary,
    ).animate(_buttonController!);
  }

  void _disposeAnimationController() {
    if (!_isControllerDisposed) {
      _buttonController?.dispose();
      _isControllerDisposed = true; // Marcar como eliminado
    }
  }

  @override
  void dispose() {
    _cubitSubscription?.cancel(); // Cancelar la suscripción al stream
    _disposeAnimationController(); // Eliminar el controlador si es necesario
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.sm),
          bottomRight: Radius.circular(AppRadius.sm),
        ),
      ),
      title: Text(widget.title),
      centerTitle: true,
      leading: widget.isForReturn
          ? IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: scheme.onSurface, size: 26),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : animatedMenu
              ? AnimatedBuilder(
                  animation: _buttonController!,
                  builder: (context, child) {
                    return IconButton(
                      icon: Icon(Icons.menu_rounded,
                          color: _buttonAnimation!.value ?? scheme.onSurface, size: 26),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                )
              : IconButton(
                  icon: Icon(Icons.menu_rounded, color: scheme.primary, size: 26),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
      actions: widget.actions,
    );
  }
}

const Map<String, bool> animatedMenuBools = {
  "registerSuccess": false,
  "register": false,
  'firstTestCompleted': true,
};
