import 'package:emotions_and_care_v1/demo/demo_config.dart';
import 'package:emotions_and_care_v1/demo/repositories/demo_cart_repository.dart';
import 'package:emotions_and_care_v1/demo/repositories/demo_note_repository.dart';
import 'package:emotions_and_care_v1/demo/repositories/demo_notification_repository.dart';
import 'package:emotions_and_care_v1/demo/repositories/demo_schedule_repository.dart';
import 'package:emotions_and_care_v1/demo/repositories/demo_test_repository.dart';
import 'package:emotions_and_care_v1/demo/repositories/demo_ui_repository.dart';
import 'package:emotions_and_care_v1/demo/repositories/demo_user_repository.dart';
import 'package:emotions_and_care_v1/helpers/navigation_bloc.dart';
import 'package:emotions_and_care_v1/helpers/notifications_cubit.dart';
import 'package:emotions_and_care_v1/helpers/paths.dart';
import 'package:emotions_and_care_v1/modules/patients_request/presentation/logic/patient_request_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Registro asincrónico de SharedPreferences
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });

  // Registro asincrónico de StorageRepository
  getIt.registerSingleton<StorageRepository>(StorageRepository(
    sharedPreferences: await getIt.getAsync<SharedPreferences>(),
  ));

  // Otros registros de objetos sincrónicos
  getIt.registerSingleton<NavigationBloc>(NavigationBloc(NavigationItem.home));

  // En modo demo, cada repositorio se registra contra su interfaz con una
  // implementación en memoria en vez de la real (que habla con la API de
  // Azure). El resto de la app (cubits, pantallas) no cambia: siguen
  // dependiendo de las mismas interfaces de siempre.
  getIt.registerSingleton<IUserRepository>(
      kDemoMode ? DemoUserRepository() : UserRepository());
  getIt.registerSingleton<UIRepository>(
      kDemoMode ? DemoUIRepository() : UIRepositoryImpl());

  // Usa `getIt<StorageRepository>()` sólo después de que se asegure su disponibilidad
  getIt.registerSingleton<UICubit>(UICubit(
    storageRepository: getIt<StorageRepository>(),
    uiRepoitory: getIt<UIRepository>(),
  ));

  getIt.registerSingleton<BegginCubit>(BegginCubit(
    storageRepository: getIt<StorageRepository>(),
    userRepoitory: getIt<IUserRepository>(),
  ));

  getIt.registerSingleton<ICartRepository>(
      kDemoMode ? DemoCartRepository() : CartRepository());
  getIt.registerSingleton<CommunityCubit>(
      CommunityCubit(repository: getIt<ICartRepository>()));

  // El módulo de emociones ya trabaja con datos fijos en el propio cubit,
  // por lo que no depende de la API en ningún modo.
  getIt.registerSingleton<EmotionRepository>(EmotionRepository());
  getIt.registerSingleton<EmotionCubit>(EmotionCubit());

  getIt.registerSingleton<INotificationRepository>(
      kDemoMode ? DemoNotificationRepository() : NotificationRepository());
  getIt.registerSingleton<HomeCubit>(
      HomeCubit(repository: getIt<INotificationRepository>()));

  // Los repositorios de especialista no se usan en el flujo de estudiante
  // que cubre la demo, así que se mantienen sin cambios: nunca se llaman
  // porque el modo demo siempre entra como paciente.
  getIt.registerSingleton<SpecialistRepository>(SpecialistRepository());
  getIt.registerSingleton<PattientsCubit>(
      PattientsCubit(repository: getIt<SpecialistRepository>()));

  getIt.registerSingleton<INoteRepository>(
      kDemoMode ? DemoNoteRepository() : NoteRepository());
  getIt.registerSingleton<DailyCubit>(
      DailyCubit(repository: getIt<INoteRepository>()));

  getIt.registerSingleton<IScheduleRepository>(
      kDemoMode ? DemoScheduleRepository() : ScheduleRepository());
  getIt.registerSingleton<ScheduleCubit>(
      ScheduleCubit(repository: getIt<IScheduleRepository>()));

  getIt.registerSingleton<ITestRepository>(
      kDemoMode ? DemoTestRepository() : TestRepository());
  getIt.registerSingleton<TestCubit>(TestCubit(
    repository: getIt<ITestRepository>(),
  ));

  //PattientsDatesCubit
  getIt.registerSingleton<PattientsDatesCubit>(PattientsDatesCubit(
    repository: getIt<IScheduleRepository>(),
  ));

  getIt.registerSingleton<PatientsRequestCubit>(PatientsRequestCubit(
    userRepository: getIt<IUserRepository>(),
    specialistRepository: getIt<SpecialistRepository>(),
  ));

  getIt
      .registerSingleton<FirebaseNotificationsCubit>(FirebaseNotificationsCubit(
    begginCubit: getIt<BegginCubit>(),
    homeCubit: getIt<HomeCubit>(),
    patientsRequestCubit: getIt<PatientsRequestCubit>(),
  ));

  // En modo demo no hay Firebase inicializado (ver main.dart), así que no se
  // debe pedir permiso de notificaciones ni tokens de FCM.
  if (!kDemoMode) {
    getIt<FirebaseNotificationsCubit>().initialize();
  }

  // Espera a que las instancias asincrónicas estén listas antes de continuar
  await getIt.allReady();
}
