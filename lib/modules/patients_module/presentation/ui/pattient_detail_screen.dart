import 'package:lottie/lottie.dart';
import '../../../../helpers/paths.dart';
import '../../../../widgets/header_specialist_widget.dart';

class PatientDetail extends StatefulWidget {
  final PatientModel patient;
  const PatientDetail({super.key, required this.patient});

  @override
  State<PatientDetail> createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  bool isloading = false;
  bool aceptedLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSpecialistWidget(
        title: '',
        isForReturn: true,
        context: context,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Text(
                      widget.patient.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: AppColors.shadowWarm),
                    ),
                    Text(
                      "Vinculado desde: ***",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cake_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          "${widget.patient.age} años",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Icon(Icons.wc_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          widget.patient.sex!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: AppColors.shadowWarm),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.mail_rounded,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Correo electrónico",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              color: AppColors.shadowWarm
                                                  .withOpacity(0.7)),
                                    ),
                                    Text(
                                      widget.patient.email!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppColors.shadowWarm),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(Icons.phone_rounded,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teléfono",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              color: AppColors.shadowWarm
                                                  .withOpacity(0.7)),
                                    ),
                                    Text(
                                      widget.patient.phone!,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppColors.shadowWarm),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 15),
                    //           child: Text("Programar cita",
                    //               textAlign: TextAlign.start,
                    //               style: TextStyle(
                    //                   color: Colors.black,
                    //                   fontSize:
                    //                       MediaQuery.of(context).size.width * 0.05,
                    //                   fontWeight: FontWeight.bold)),
                    //         ),
                    //         SizedBox(
                    //           height: MediaQuery.of(context).size.height * 0.005,
                    //         ),
                    //         GestureDetector(
                    //           onTap: () {},
                    //           child: Container(
                    //             decoration: BoxDecoration(
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   color: Colors.grey.withOpacity(0.3),
                    //                   spreadRadius: 1,
                    //                   blurRadius: 5,
                    //                   offset: const Offset(
                    //                       0, 3), // changes position of shadow
                    //                 ),
                    //               ],
                    //             ),
                    //             child: Column(
                    //               children: [
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: const BorderRadius.only(
                    //                       topLeft: Radius.circular(10),
                    //                       topRight: Radius.circular(10),
                    //                     ),
                    //                     color:
                    //                         Theme.of(context).colorScheme.primary,
                    //                   ),
                    //                   width: double.infinity,
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 10, vertical: 10),
                    //                   margin: EdgeInsets.symmetric(
                    //                     horizontal:
                    //                         MediaQuery.of(context).size.height *
                    //                             0.015,
                    //                   ),
                    //                   child: const Row(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     mainAxisAlignment: MainAxisAlignment.start,
                    //                     children: [
                    //                       Expanded(
                    //                           child: Row(
                    //                         children: [
                    //                           Icon(
                    //                             Icons.calendar_month,
                    //                             color: Colors.white,
                    //                           ),
                    //                           SizedBox(
                    //                             width: 10,
                    //                           ),
                    //                           Text("Later",
                    //                               style: TextStyle(
                    //                                   color: Colors.white,
                    //                                   fontWeight: FontWeight.bold)),
                    //                         ],
                    //                       )),
                    //                       Expanded(
                    //                           child: Row(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.end,
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.end,
                    //                         children: [
                    //                           Icon(Icons.schedule,
                    //                               color: Colors.white),
                    //                           SizedBox(
                    //                             width: 10,
                    //                           ),
                    //                           Text("Later",
                    //                               style: TextStyle(
                    //                                   color: Colors.white,
                    //                                   fontWeight: FontWeight.bold)),
                    //                         ],
                    //                       )),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 containerItem(
                    //                     context, Colors.white, "Later", 'Later', "",
                    //                     () {
                    //                   //onTap(date);
                    //                 },
                    //                     hasHeader: true,
                    //                     icon: Icons.info_outline_rounded),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.05,
                    //     ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AppButton.secondary(
                    isLoading: isloading,
                    label: 'Diario',
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DailyController(
                                  patientModel: widget.patient,
                                  changeIndex: null,
                                  isPattient: false)));
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    isLoading: aceptedLoading,
                    label: 'Cuestionarios',
                    onPressed: () async {
                      context.read<TestCubit>().getTest(widget.patient.id!);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BlocBuilder<TestCubit, TestState>(
                          bloc: context.read<TestCubit>(),
                          builder: (context, state) {
                            if (state.status == TestStatus.error) {
                              return Scaffold(
                                body: AppErrorState(
                                  message: 'No pudimos cargar los cuestionarios.',
                                  onRetry: () => context
                                      .read<TestCubit>()
                                      .getTest(widget.patient.id!),
                                ),
                              );
                            }

                            if (state.status == TestStatus.loading) {
                              return Scaffold(
                                body: Center(
                                  child: Lottie.asset(Assets.brainLoading),
                                ),
                              );
                            }

                            return TestProgressScreen(
                              patientModel: widget.patient,
                              historyTestList: state.historyTestList,
                              isPatient: false,
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
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TestHistoryQuestionsScreen(
                                            test: testInfo,
                                          );
                                        }));
                                      });
                                }));
                              },
                            );
                          },
                        );
                      }));
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
