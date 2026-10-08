import 'package:lottie/lottie.dart';
import '../../../../helpers/paths.dart';

class TestController extends StatefulWidget {
  final PatientModel patientModel;
  final Function(int) changeIndex;
  const TestController(
      {super.key, required this.patientModel, required this.changeIndex});

  @override
  State<TestController> createState() => _TestControllerState();
}

class _TestControllerState extends State<TestController> {
  late final TestCubit _testCubit;

  @override
  void initState() {
    _testCubit = getIt<TestCubit>();

    if (_testCubit.state.testList.isEmpty) {
      _testCubit.getTest(widget.patientModel.id!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestCubit, TestState>(
      bloc: context.read<TestCubit>(),
      builder: (context, state) {
        if (state.status == TestStatus.error) {
          return Scaffold(
            body: AppErrorState(
              message: 'No pudimos cargar tus cuestionarios.',
              onRetry: () =>
                  context.read<TestCubit>().getTest(widget.patientModel.id!),
            ),
          );
        }

        return Scaffold(
          body: state.status == TestStatus.loading
              ? Center(
                  child: Lottie.asset(Assets.brainLoading),
                )
              : TestsScreen(
                  testList: state.testList,
                  completedTestList: state.completedTestList,
                  onTestTap: (TestModel test) {
                    if (state.completedTestList
                        .any((element) => element.testId == test.id)) {
                      showDialogForCompletedTest(
                          context,
                          state.completedTestList
                              .firstWhere(
                                  (element) => element.testId == test.id)
                              .date);
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CompleteTest(
                          testId: test.id,
                          userId: widget.patientModel.id!,
                          onTap: (int testId, int questionId, int responseId) {
                            context.read<TestCubit>().onSelectResponse(
                                  testId,
                                  questionId,
                                  responseId,
                                );
                          },
                        ),
                      ),
                    );
                  },
                  onRefresh: () async {
                    context.read<TestCubit>().getTest(widget.patientModel.id!);
                  },
                ),
        );
      },
    );
  }
}
