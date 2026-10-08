// ignore_for_file: avoid_types_as_parameter_names
import 'package:emotions_and_care_v1/modules/patients_request/presentation/ui/patient_request_controller.dart';
import 'package:emotions_and_care_v1/modules/yard_module/presentation/ui/goals_room.dart';
import '../../helpers/navigation_bloc.dart';
import '../../helpers/paths.dart';

class LoginStack extends StatefulWidget {
  const LoginStack({super.key});

  @override
  State<LoginStack> createState() => _LoginStackState();
}

class _LoginStackState extends State<LoginStack> {
  late BegginCubit userProvider;

  @override
  void initState() {
    userProvider = getIt<BegginCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userProvider.state.status == BegginStatus.loading) {
      return const Scaffold(
        body: Center(
          child: AppLoadingIndicator(size: 36),
        ),
      );
    }

    if (userProvider.state.isPatient == true) {
      return const PattientStack();
    } else {
      return const SpecialistStack();
    }
  }
}

class PattientStack extends StatefulWidget {
  const PattientStack({super.key});

  @override
  State<PattientStack> createState() => _PattientStackState();
}

class _PattientStackState extends State<PattientStack> {
  late NavigationBloc navigationBloc;
  late BegginCubit begginCubit;
  late CommunityCubit communityCubit;
  late DailyCubit dailyCubit;
  late EmotionCubit emotionCubit;
  late ScheduleCubit scheduleCubit;
  late HomeCubit homeCubit;
  late TestCubit testCubit;
  late PattientsDatesCubit pattientsDatesCubit;
  late UICubit uiCubit;
  late Widget _content;

  @override
  void initState() {
    uiCubit = getIt<UICubit>();
    begginCubit = getIt<BegginCubit>();

    navigationBloc = NavigationBloc(
      NavigationItem.home,
    );

    communityCubit = getIt<CommunityCubit>();
    dailyCubit = getIt<DailyCubit>();
    emotionCubit = getIt<EmotionCubit>();
    scheduleCubit = getIt<ScheduleCubit>();
    homeCubit = getIt<HomeCubit>();
    testCubit = getIt<TestCubit>();
    pattientsDatesCubit = getIt<PattientsDatesCubit>();

    _content = _getContentForState(
      navigationBloc.state.selectedItem,
      begginCubit,
      communityCubit,
      dailyCubit,
      emotionCubit,
      scheduleCubit,
      homeCubit,
      pattientsDatesCubit,
      testCubit,
      uiCubit,
    );

    uiCubit.setBackAssets(
      begginCubit.state.patientModel!.userInterface!.userStickers,
      begginCubit.state.patientModel!.userInterface!.userFlowers,
      begginCubit.state.patientModel!.achivementCollection?.userAchievements ??
          [],
      begginCubit.state.patientModel!.userInterface!.themeId ?? 0,
      begginCubit.state.patientModel!.userInterface!.backgroundUrl ?? 0,
    );

    homeCubit.canGrowStage(begginCubit.state.patientModel!.id!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: navigationBloc,
      child: BlocConsumer<NavigationBloc, NavigationState>(
        listener: (BuildContext context, NavigationState state) {
          setState(() {
            _content = _getContentForState(
                state.selectedItem,
                begginCubit,
                communityCubit,
                dailyCubit,
                emotionCubit,
                scheduleCubit,
                homeCubit,
                pattientsDatesCubit,
                testCubit,
                uiCubit);
          });
        },
        buildWhen: (previous, current) {
          return previous.selectedItem != current.selectedItem;
        },
        listenWhen: (previous, current) {
          return previous.selectedItem != current.selectedItem;
        },
        builder: (BuildContext context, NavigationState state) {
          return Scaffold(
            appBar: _getAppBarFromState(
                state.selectedItem,
                navigationBloc,
                begginCubit,
                communityCubit,
                dailyCubit,
                emotionCubit,
                scheduleCubit,
                homeCubit,
                testCubit,
                uiCubit,
                context),
            drawer: DrawerWidget(
              currentIndex: state.selectedItem.index,
              changeIndex: (int) {},
            ),
            body: AnimatedSwitcher(
              switchInCurve: Curves.linear,
              switchOutCurve: Curves.linear,
              duration: const Duration(milliseconds: 300),
              child: _content,
            ),
          );
        },
      ),
    );
  }
}

PreferredSizeWidget? _getAppBarFromState(
  NavigationItem selectedItem,
  NavigationBloc navigationBloc,
  BegginCubit begginCubit,
  CommunityCubit communityCubit,
  DailyCubit dailyCubit,
  EmotionCubit emotionCubit,
  ScheduleCubit scheduleCubit,
  HomeCubit homeCubit,
  TestCubit testCubit,
  UICubit uiCubit,
  BuildContext context,
) {
  switch (selectedItem) {
    case NavigationItem.home:
      return null;
    case NavigationItem.goals:
      return HeaderWidget(
        title: 'Colección',
        isForReturn: false,
        actions: [
          IconButton(
              onPressed: () {
                showMessageDialog(context, "Colección",
                    "La colección es un espacio donde puedes ver tus logros, stickers y flores. |Puedes coleccionar stickers y flores al completar tus objetivos y retos. |Recuerda que cada sticker y flor tiene un significado especial, así que asegúrate de leer su descripción.");
              },
              icon: const Icon(Icons.info_outline_rounded)),
        ],
      );
    case NavigationItem.test:
      return HeaderWidget(title: 'Cuestionarios', isForReturn: false, actions: [
        ElevatedButton(
            onPressed: () {
              if (testCubit.state.status == TestStatus.loading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cargando cuestionarios, intente de nuevo'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              if (begginCubit.state.registerPatientFlow != "registerSuccess") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No se ha completado el registro'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TestProgressScreen(
                  patientModel: begginCubit.state.patientModel!,
                  historyTestList: testCubit.state.historyTestList,
                  isPatient: true,
                  onFisrtItemTap: (TestInfoModel testInfo) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TestHistoryQuestionsScreen(
                        test: testInfo,
                      );
                    }));
                  },
                  onTap: (HistoryTestModel test) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TestHistoryItemsScreen(
                          test: test,
                          onTap: (TestInfoModel testInfo) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TestHistoryQuestionsScreen(
                                test: testInfo,
                              );
                            }));
                          });
                    }));
                  },
                );
              }));
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            ),
            child: const Text('Progreso')),
        const SizedBox(width: AppSpacing.sm),
      ]);
    case NavigationItem.dairy:
      return HeaderWidget(title: 'Diario', isForReturn: false, actions: [
        ElevatedButton(
            onPressed: () {
              if (dailyCubit.state.result == DailyResult.loading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cargando notas, intente de nuevo'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              if (dailyCubit.state.notes.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No hay notas para mostrar'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotesProgressScreen(
                      isPattient: true,
                      notes: dailyCubit.state.notes,
                      patientModel: begginCubit.state.patientModel!)));
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            ),
            child: const Text('Progreso')),
        const SizedBox(width: AppSpacing.sm),
      ]);
    case NavigationItem.community:
      return HeaderWidget(
        title: 'Comunidad',
        isForReturn: false,
        actions: [
          IconButton(
              onPressed: () {
                showMessageDialog(context, "Comunidad",
                    "Emotions&Care cuenta con una comunidad constituida por todos los usuarios, en ella puedes escribir cartas anónimas para compartir tus sentimientos y recibir apoyo. |De igual forma, puedes responder a las cartas de otros para brindar aliento y comprensión.");
              },
              icon: const Icon(Icons.info_outline_rounded)),
        ],
      );
    case NavigationItem.schedule:
      return const HeaderWidget(title: 'Agenda', isForReturn: false);
    case NavigationItem.settings:
      return const HeaderWidget(title: 'Configuración', isForReturn: false);
    case NavigationItem.patients:
      return null;
    case NavigationItem.scheduleSpecialist:
      return null;
    case NavigationItem.patientDates:
      return null;
  }
}

Widget _getContentForState(
  NavigationItem selectedItem,
  BegginCubit begginCubit,
  CommunityCubit communityCubit,
  DailyCubit dailyCubit,
  EmotionCubit emotionCubit,
  ScheduleCubit scheduleCubit,
  HomeCubit homeCubit,
  PattientsDatesCubit pattientsDatesCubit,
  TestCubit testCubit,
  UICubit uiCubit,
) {
  switch (selectedItem) {
    case NavigationItem.home:
      return HomeController(
        idUser: begginCubit.state.patientModel!.id!,
        changeIndex: (int) {},
        begginState: begginCubit.state,
      );
    case NavigationItem.goals:
      return const GoalsRoom();
    case NavigationItem.test:
      return TestController(
        patientModel: begginCubit.state.patientModel!,
        changeIndex: (int) {},
      );
    case NavigationItem.dairy:
      return DailyController(
          patientModel: begginCubit.state.patientModel!,
          changeIndex: (int) {},
          isPattient: begginCubit.state.isPatient!);
    case NavigationItem.community:
      return GlobalCommunityController(
          isPatient: begginCubit.state.isPatient!,
          patientModel: begginCubit.state.patientModel);
    case NavigationItem.schedule:
      return ScheduleController(
        isPattient: begginCubit.state.isPatient!,
      );
    case NavigationItem.settings:
      return SettingsController(
        userProvider: begginCubit,
        isPattient: begginCubit.state.isPatient!,
        logout: () {
          scheduleCubit.clean();
          homeCubit.clean();
          // emotionCubit.clean();
          communityCubit.clean();
          dailyCubit.clean();
          testCubit.clean();
          uiCubit.clean();
          begginCubit.logout();
          pattientsDatesCubit.clean();
        },
      );
    case NavigationItem.patients:
      return Container();
    case NavigationItem.scheduleSpecialist:
      return Container();
    case NavigationItem.patientDates:
      return Container();
  }
}

class SpecialistStack extends StatefulWidget {
  const SpecialistStack({super.key});

  @override
  State<SpecialistStack> createState() => _SpecialistStackState();
}

class _SpecialistStackState extends State<SpecialistStack>
    with AutomaticKeepAliveClientMixin {
  bool loading = true;
  late NavigationBloc navigationBloc;
  late BegginCubit begginCubit;
  late CommunityCubit communityCubit;
  late DailyCubit dailyCubit;
  late EmotionCubit emotionCubit;
  late ScheduleCubit scheduleCubit;
  late HomeCubit homeCubit;
  late TestCubit testCubit;
  late PattientsDatesCubit pattientsDatesCubit;
  late UICubit uiCubit;

  @override
  void initState() {
    uiCubit = getIt<UICubit>();
    begginCubit = getIt<BegginCubit>();

    navigationBloc = NavigationBloc(
      NavigationItem.home,
    );

    communityCubit = getIt<CommunityCubit>();
    dailyCubit = getIt<DailyCubit>();
    emotionCubit = getIt<EmotionCubit>();
    scheduleCubit = getIt<ScheduleCubit>();
    homeCubit = getIt<HomeCubit>();
    testCubit = getIt<TestCubit>();
    pattientsDatesCubit = getIt<PattientsDatesCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (begginCubit.state.specialistModel != null) {
        await context.read<PattientsCubit>().getPattients(
              begginCubit.state.specialistModel!.id!,
            );
      }

      if (mounted && begginCubit.state.specialistModel != null) {
        await context.read<ScheduleCubit>().getDatesForSpecialist(
              begginCubit.state.specialistModel!.id!,
            );
      }

      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  // @override
  // void dispose() {
  //   navigationBloc.close();
  //   super.dispose();
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: loading
          ? const Center(child: AppLoadingIndicator(size: 36))
          : SafeArea(
              top: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(children: [
                  headerSpecialistWidget(),
                  const SizedBox(height: AppSpacing.xl),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _dashboardCard(
                            context,
                            icon: Icons.event_note_rounded,
                            label: "Solicitudes de citas",
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PattientsDatesController(
                                  idUser:
                                      begginCubit.state.specialistModel!.id!,
                                );
                              }));
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: _dashboardCard(
                            context,
                            icon: Icons.person_add_alt_1_rounded,
                            label: "Vinculación de pacientes",
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PatientsRequestController(
                                  idUser:
                                      begginCubit.state.specialistModel!.id!,
                                );
                              }));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _dashboardCard(
                    context,
                    icon: Icons.event_rounded,
                    label: "Agenda",
                    fullWidth: true,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ScheduleController(
                          isPattient: false,
                        );
                      }));
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _dashboardCard(
                    context,
                    icon: Icons.groups_rounded,
                    label: "Pacientes",
                    fullWidth: true,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SpecialistPattientsController(
                          idUser: begginCubit.state.specialistModel!.id!,
                        );
                      }));
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _dashboardCard(
                    context,
                    icon: Icons.diversity_3_rounded,
                    label: "Comunidad",
                    fullWidth: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GlobalCommunityController(
                            specialistModel: begginCubit.state.specialistModel!,
                            isPatient: false,
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
    );
  }

  Widget _dashboardCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: fullWidth ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
          child: Icon(icon, color: scheme.primary, size: 22),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          label,
          textAlign: fullWidth ? TextAlign.start : TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );

    if (!fullWidth) {
      return AppCard(onTap: onTap, child: content);
    }

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(icon, color: scheme.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
          Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withOpacity(0.4)),
        ],
      ),
    );
  }

  Widget headerSpecialistWidget() {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("¡Hola ${begginCubit.state.specialistModel!.name!}!",
                    style: Theme.of(context).textTheme.headlineSmall),
                Text(getDate(context), style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsController(
                    userProvider: begginCubit,
                    isPattient: false,
                    logout: () {
                      scheduleCubit.clean();
                      homeCubit.clean();
                      // emotionCubit.clean();
                      communityCubit.clean();
                      dailyCubit.clean();
                      testCubit.clean();
                      uiCubit.clean();

                      pattientsDatesCubit.clean();

                      begginCubit.logout();
                    },
                  );
                }));
              },
              icon: Icon(
                Icons.settings_rounded,
                color: scheme.onSurface,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_rounded,
                color: scheme.onSurface,
              ))
        ],
      ),
    );
  }
}

String getDate(BuildContext context) {
//formato: Miércoles 15 de septiembre de 2021
  final DateTime now = DateTime.now().toLocal();
  final String day = now.day.toString();
  final String month = now.month.toString();
  // final String year = now.year.toString();

  switch (now.weekday) {
    case 1:
      return "Lunes $day de ${getMonth(month)}";
    case 2:
      return "Martes $day de ${getMonth(month)}";
    case 3:
      return "Miércoles $day de ${getMonth(month)}";
    case 4:
      return "Jueves $day de ${getMonth(month)}";
    case 5:
      return "Viernes $day de ${getMonth(month)}";
    case 6:
      return "Sábado $day de ${getMonth(month)}";
    case 7:
      return "Domingo $day de ${getMonth(month)}";
    default:
      return "";
  }
}

String getMonth(String month) {
  switch (month) {
    case "1":
      return "Enero";
    case "2":
      return "Febrero";
    case "3":
      return "Marzo";
    case "4":
      return "Abril";
    case "5":
      return "Mayo";
    case "6":
      return "Junio";
    case "7":
      return "jJlio";
    case "8":
      return "Agosto";
    case "9":
      return "Septiembre";
    case "10":
      return "Octubre";
    case "11":
      return "Noviembre";
    case "12":
      return "Diciembre";
    default:
      return "";
  }
}
