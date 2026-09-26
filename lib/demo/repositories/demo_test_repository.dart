import '../../helpers/paths.dart';
import '../demo_data_store.dart';

/// Reemplazo en memoria de [ITestRepository] (módulo Cuestionarios) para el
/// modo demo.
class DemoTestRepository implements ITestRepository {
  @override
  Future<CompleteTestHistory> getTest(int pacienteId) async {
    return CompleteTestHistory(
      historyTestList: List<HistoryTestModel>.from(DemoDataStore.historyTests),
      completedTestList: List<CompletedTestModel>.from(DemoDataStore.completedTests),
      testList: List<TestModel>.from(DemoDataStore.tests),
    );
  }

  @override
  Future<TestInfoModelWithAchivement> completeTest(int idPaciente, int isTest,
      List<QuestionModel> questions, bool isFirtsTime) async {
    final List<TestQuestionWithAnswer> answered = questions.map((q) {
      final ResponseModel selected = q.answers.firstWhere(
        (a) => a.isSelected,
        orElse: () => q.answers.first,
      );
      return TestQuestionWithAnswer(
        id: q.id,
        question: q.question,
        answer: selected.response,
      );
    }).toList();

    final TestInfoModel testInfo = TestInfoModel(
      id: DemoDataStore.nextTestInfoId,
      resultado: 'Cuestionario completado en modo demostración. '
          'Esto no es un diagnóstico ni sustituye la atención de un profesional.',
      date: DateTime.now(),
      testQuestionWithAnswerList: answered,
    );

    DemoDataStore.completedTests.add(CompletedTestModel(
      testId: isTest,
      date: DateTime.now(),
      userId: idPaciente,
    ));

    return TestInfoModelWithAchivement(
      testInfoModel: testInfo,
      achivementId: isFirtsTime ? 5 : null,
    );
  }
}
