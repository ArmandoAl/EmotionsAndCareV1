import '../../../../helpers/paths.dart';

class TestCubit extends Cubit<TestState> {
  final ITestRepository repository;
  TestCubit({required this.repository}) : super(const TestState());

  //complete test
  Future<TestInfoModelWithAchivement> onCompleteTest(
      int patientId, int testId, bool isFirtsTime) async {
    final test = state.testList.firstWhere((element) => element.id == testId);

    TestInfoModelWithAchivement result = await repository.completeTest(
        patientId,
        testId,
        test.questions,
        state.completedTestList.isEmpty ? true : false);

    final List<CompletedTestModel> updatedCompletedTestList;

    if (state.completedTestList.isEmpty) {
      updatedCompletedTestList = [
        ...state.completedTestList,
        CompletedTestModel(
          userId: patientId,
          testId: testId,
          date: DateTime.now().toLocal(),
        ),
      ];
    } else {
      updatedCompletedTestList = state.completedTestList
          .map((e) => e.testId == testId
              ? e.copyWith(date: DateTime.now().toLocal())
              : e)
          .toList();
    }

    final List<HistoryTestModel> updatedHistoryList;

    if (state.historyTestList.isEmpty) {
      updatedHistoryList = [
        ...state.historyTestList,
        HistoryTestModel(
          id: 1,
          name: test.name,
          idCuestionario: testId,
          testInfoList: [result.testInfoModel!],
        ),
      ];
    } else {
      updatedHistoryList = state.historyTestList
          .map((e) => e.idCuestionario == testId
              ? e.copyWith(
                  testInfoList: [result.testInfoModel!, ...e.testInfoList],
                )
              : e)
          .toList();
    }

    clearTest(test);

    // Emit a new state with the updated list of completed tests
    emit(state.copyWith(
      completedTestList: updatedCompletedTestList,
      historyTestList: updatedHistoryList,
    ));

    return result;
  }

  void clearTest(TestModel test) {
    final updatedTestList = state.testList
        .map((e) => e.id == test.id
            ? e.copyWith(
                questions: e.questions
                    .map((q) => q.copyWith(
                        answers: q.answers
                            .map((a) => a.copyWith(isSelected: false))
                            .toList()))
                    .toList())
            : e)
        .toList();
    emit(state.copyWith(testList: updatedTestList));
  }

  Future<void> getTest(int userId) async {
    emit(state.copyWith(status: TestStatus.loading));
    try {
      final CompleteTestHistory testList = await repository.getTest(userId);
      emit(state.copyWith(
          testList: testList.testList,
          completedTestList: testList.completedTestList,
          historyTestList: testList.historyTestList,
          status: TestStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: TestStatus.error));
    }
  }

  //select question response
  void onSelectResponse(int testId, int questionId, int position) {
    // Create a new list of tests with the updated test
    final updatedTestList = state.testList
        .map((e) => e.id == testId
            ? e.copyWith(
                questions: e.questions
                    .map((q) => q.id == questionId
                        ? q.copyWith(
                            answers: q.answers
                                .map((a) => a.copyWith(
                                    isSelected:
                                        q.answers.indexOf(a) == position))
                                .toList())
                        : q)
                    .toList())
            : e)
        .toList();

    // Emitir un nuevo estado con la lista de pruebas actualizada
    emit(state.copyWith(testList: updatedTestList));
  }

  void clean() {
    emit(const TestState());
  }
}
