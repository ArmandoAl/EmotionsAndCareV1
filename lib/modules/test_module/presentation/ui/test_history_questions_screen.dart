import '../../../../helpers/paths.dart';

class TestHistoryQuestionsScreen extends StatefulWidget {
  final TestInfoModel test;
  const TestHistoryQuestionsScreen({super.key, required this.test});

  @override
  State<TestHistoryQuestionsScreen> createState() =>
      _TestHistoryQuestionsScreenState();
}

class _TestHistoryQuestionsScreenState
    extends State<TestHistoryQuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            Text(widget.test.resultado,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: AppColors.shadowWarm)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "${widget.test.date.day}/${widget.test.date.month}/${widget.test.date.year} ${widget.test.date.hour}:${widget.test.date.minute}",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.test.testQuestionWithAnswerList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      testHistoryQuestion(context,
                          widget.test.testQuestionWithAnswerList[index], index),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget testHistoryQuestion(
    BuildContext context, TestQuestionWithAnswer question, int index) {
  final ColorScheme scheme = Theme.of(context).colorScheme;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pregunta ${index + 1}",
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.6))),
        const SizedBox(height: AppSpacing.xs),
        Text(
          question.question,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: AppColors.shadowWarm),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: AppShadows.soft,
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            question.answer,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: scheme.onPrimaryContainer),
          ),
        ),
      ],
    ),
  );
}
