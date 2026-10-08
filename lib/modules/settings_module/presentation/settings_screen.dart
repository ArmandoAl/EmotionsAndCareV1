import 'dart:async';

import '../../../helpers/paths.dart';

class SettingsScreen extends StatefulWidget {
  final BegginCubit userProvider;
  final bool isPattient;
  final UICubit uiProvider;
  final Function logout;
  const SettingsScreen(
      {super.key,
      required this.userProvider,
      required this.isPattient,
      required this.uiProvider,
      required this.logout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late BegginCubit userProvider;
  bool animatedMenu = true;
  AnimationController? _animationController;
  Animation<Color?>? _animation;
  bool _isControllerDisposed = false;
  bool _dialogShown = false; // Evitar mostrar el diálogo más de una vez

  StreamSubscription? _cubitSubscription;

  @override
  void initState() {
    super.initState();
    userProvider = widget.userProvider;

    animatedMenu = animatedMenuBools[
        userProvider.state.registerPatientFlow ?? "registerSuccess"]!;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Solo mostrar el diálogo si estamos en el tutorial (animatedMenu es true)
    if (animatedMenu && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMessageDialog(context, "¡Hora de personalizar tu espacio!",
            "A continuación podrás personalizar tu jardín, tal será tu pantalla principal por ello debe inspirarte y reflejar tu esencia e identidad.");
      });
    }
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
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ListView(
        children: [
          headerItem(
            context,
            widget.isPattient ? widget.userProvider.state.patientModel! : null,
            widget.isPattient
                ? null
                : widget.userProvider.state.specialistModel ??
                    SpecialistModel(),
            widget.isPattient,
            widget.userProvider,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (widget.isPattient)
            listItem(
                context,
                "Personalización",
                Icon(Icons.palette_rounded, color: scheme.tertiary),
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomMenuScreen(
                    userProvider: widget.userProvider,
                    uiProvider: widget.uiProvider,
                  ),
                ),
              );
            }, false, animatedMenu, _animationController, _animation),
          if (widget.isPattient) const SizedBox(height: AppSpacing.lg),
          if (widget.isPattient)
            listItem(
                context,
                "Privacidad",
                Icon(Icons.privacy_tip_rounded, color: scheme.primary),
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyScreen(
                    settings: widget.isPattient
                        ? widget.userProvider.state.patientModel!.settings
                        : widget.userProvider.state.patientModel!.settings,
                  ),
                ),
              );
            }, animatedMenu, false, _animationController, _animation),
          if (widget.isPattient) const SizedBox(height: AppSpacing.lg),
          listItem(
              context,
              "Términos y Condiciones",
              Icon(Icons.description_rounded, color: scheme.secondary), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TermsScreen(
                  terms: widget.isPattient
                      ? widget
                          .userProvider.state.patientModel!.termsClass!.terms
                      : widget.userProvider.state.specialistModel!.termsClass!
                          .terms,
                ),
              ),
            );
          }, animatedMenu, false, _animationController, _animation),
          const SizedBox(height: AppSpacing.lg),
          listItem(
              context, "Acerca de", Icon(Icons.info_rounded, color: scheme.secondary),
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutScreen(),
              ),
            );
          }, animatedMenu, false, _animationController, _animation),
          const SizedBox(height: AppSpacing.lg),
          listItem(
              context,
              "Cerrar Sesión",
              Icon(Icons.exit_to_app_rounded, color: scheme.error), () async {
            final bool confirmed = await showAppConfirmDialog(
              context,
              title: 'Cerrar sesión',
              message: '¿Estás seguro de que quieres cerrar tu sesión?',
              confirmLabel: 'Cerrar sesión',
              isDestructive: true,
            );
            if (!confirmed || !context.mounted) return;

            if (widget.isPattient == false) {
              Navigator.pop(context);
            }
            widget.logout();
          }, animatedMenu, false, _animationController, _animation),
        ],
      ),
    );
  }
}

Widget listItem(
  BuildContext context,
  String title,
  Icon icon,
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
        icon,
        const SizedBox(width: AppSpacing.md),
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
        const SizedBox(width: AppSpacing.sm),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: disable
              ? AppColors.shadowWarm.withOpacity(0.3)
              : AppColors.shadowWarm.withOpacity(0.5),
        )
      ],
    ),
  );
}

Widget headerItem(
  BuildContext context,
  PatientModel? patientModel,
  SpecialistModel? specialistModel,
  bool isPattient,
  BegginCubit userProvider,
) {
  final ColorScheme scheme = Theme.of(context).colorScheme;
  return AppCard(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            patientModel: patientModel,
            specialistModel: specialistModel,
            userProvider: userProvider,
            isPatient: isPattient,
          ),
        ),
      );
    },
    child: Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: scheme.primaryContainer,
          child: Icon(Icons.person_rounded, color: scheme.primary, size: 28),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textToUpperCateFirstLetter(isPattient
                    ? patientModel!.name ?? ""
                    : specialistModel!.name ?? ""),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.shadowWarm),
              ),
              Text(
                isPattient
                    ? patientModel!.email ?? ''
                    : specialistModel!.email ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.shadowWarm.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: AppColors.shadowWarm.withOpacity(0.5),
        )
      ],
    ),
  );
}
