import 'dart:async';

import 'package:emotions_and_care_v1/firebase_options.dart';
import 'package:emotions_and_care_v1/helpers/notifications_cubit.dart';
import 'package:emotions_and_care_v1/modules/patients_request/presentation/logic/patient_request_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'demo/demo_config.dart';
import 'demo/widgets/demo_banner.dart';
import 'helpers/navigation_bloc.dart';
import 'helpers/paths.dart';
import 'modules/auth_module/presentation/ui/beggin_process_controller.dart';

void main() async {
  FlutterError.onError = (details) {
    // ignore: avoid_print
    print('FLUTTER_ERROR: ${details.exceptionAsString()}\n${details.stack}');
  };
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // En modo demo no se inicializa Firebase: la demo no debe depender de
    // notificaciones push ni de ningún servicio del backend real.
    if (!kDemoMode) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await setupServiceLocator();
    runApp(const MyApp());
  }, (error, stack) {
    // ignore: avoid_print
    print('ZONE_ERROR: $error\n$stack');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BegginCubit>(
          create: (context) => getIt<BegginCubit>(),
        ),
        BlocProvider<NavigationBloc>(
          create: (context) => getIt<NavigationBloc>(),
        ),
        BlocProvider<EmotionCubit>(
          create: (context) => getIt<EmotionCubit>(),
        ),
        BlocProvider<CommunityCubit>(
          create: (context) => getIt<CommunityCubit>(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => getIt<HomeCubit>(),
        ),
        BlocProvider<PattientsCubit>(
          create: (context) => getIt<PattientsCubit>(),
        ),
        BlocProvider<DailyCubit>(
          create: (context) => getIt<DailyCubit>(),
        ),
        BlocProvider<ScheduleCubit>(
          create: (context) => getIt<ScheduleCubit>(),
        ),
        BlocProvider<TestCubit>(
          create: (context) => getIt<TestCubit>(),
        ),
        BlocProvider<UICubit>(
          create: (context) => getIt<UICubit>(),
        ),
        BlocProvider<PattientsDatesCubit>(
          create: (context) => getIt<PattientsDatesCubit>(),
        ),
        BlocProvider<PatientsRequestCubit>(
          create: (context) => getIt<PatientsRequestCubit>(),
        ),
        BlocProvider<FirebaseNotificationsCubit>(
          create: (context) => getIt<FirebaseNotificationsCubit>(),
        ),
      ],
      child: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UICubit>().setUpUI();
      context.read<BegginCubit>().getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final uiCubit = context.watch<UICubit>();

    if (uiCubit.state.themes.isEmpty) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Emotions and Care',
          theme: _maybeDemoTheme(ThemeData(
            primarySwatch: Colors.blue,
          )),
          home: _maybeWithDemoBanner(const Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          )));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emotions and Care',
      theme: _maybeDemoTheme(uiCubit.state.themes[uiCubit.state.selectedTheme]),
      home: _maybeWithDemoBanner(BlocBuilder<BegginCubit, BegginState>(
        bloc: getIt<BegginCubit>(),
        builder: (context, state) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: state.status == BegginStatus.start ||
                      state.status == BegginStatus.loading
                  ? const Scaffold(
                      backgroundColor: Colors.white,
                      body: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : state.status == BegginStatus.notLoged ||
                          state.status == BegginStatus.errorInRegister
                      ? const BegginProcessController()
                      : const LoginStack() // Aquí muestra la pantalla de login cuando está logeado

              );
        },
      )),
    );
  }

  Widget _maybeWithDemoBanner(Widget child) {
    return kDemoMode ? DemoBanner(child: child) : child;
  }

  /// En modo demo, fuerza que todo el texto use la fuente ya incluida en el
  /// bundle ("Gilroy") en vez del "Roboto" por defecto de Material, que
  /// Flutter Web intenta descargar en tiempo de ejecución desde
  /// fonts.gstatic.com. Así el arranque de la demo no depende de esa red
  /// externa. No se toca en producción.
  ThemeData _maybeDemoTheme(ThemeData theme) {
    if (!kDemoMode) return theme;
    return theme.copyWith(
      textTheme: theme.textTheme.apply(fontFamily: 'Gilroy'),
      primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: 'Gilroy'),
    );
  }
}
