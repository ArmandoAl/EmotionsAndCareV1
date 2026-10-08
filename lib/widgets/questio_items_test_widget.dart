import '../helpers/paths.dart';

Widget questionItems(
  BuildContext context,
  TestState state,
  int index,
  double progress,
  PageController pageController,
  bool isLoading,
  String? resultado,
  int userId,
  void Function(int testId, int questionId, int responseId) onTap,
  int testId,
  QuestionModel item,
  Function(bool loading) setLoadingState,
  Function(String result) setResultState,
  Function(Achievement? goal) setGoal,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.sm,
    ),
    child: Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 26),
              onPressed: () {
                //change page
                pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
            ),
            const Spacer(),
            Text(
              '$index/${state.testList[testId - 1].questions.length}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.shadowWarm.withOpacity(0.6),
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Text("Pregunta ${index.toString()}",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7))),
            const Spacer()
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(item.question,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: AppColors.shadowWarm)),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: item.answers.length,
            itemBuilder: (context, index) {
              ResponseModel answer = item.answers[index];
              final ColorScheme scheme = Theme.of(context).colorScheme;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Material(
                  color: answer.isSelected
                      ? scheme.primaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: InkWell(
                    onTap: () {
                      onTap(testId, item.id, index);
                    },
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: answer.isSelected
                              ? scheme.primary
                              : AppColors.shadowWarm.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.only(right: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: answer.isSelected
                                  ? scheme.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: answer.isSelected
                                    ? scheme.primary
                                    : AppColors.shadowWarm.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: answer.isSelected
                                ? Icon(Icons.check_rounded,
                                    size: 18, color: scheme.onPrimary)
                                : null,
                          ),
                          Flexible(
                            child: Text(answer.response,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: AppColors.shadowWarm)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppButton(
            expand: true,
            isLoading: isLoading,
            label: 'Continuar',
            onPressed: () async {
              final String? registerFlow =
                  context.read<BegginCubit>().state.registerPatientFlow;
              //if the last question
              if (index == state.testList[testId - 1].questions.length) {
                setLoadingState(true);

                TestInfoModelWithAchivement result = await context
                    .read<TestCubit>()
                    .onCompleteTest(
                        userId, testId, registerFlow != "registerSuccess");

                if (result.achivementId != null && context.mounted) {
                  final UICubit uiProvider = getIt<UICubit>();

                  final achivement =
                      uiProvider.getAchivement(result.achivementId!);

                  setGoal(achivement);
                }

                setResultState(result.testInfoModel!.resultado);
              }

              if (item.answers.any((element) => element.isSelected)) {
                //change page
                pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selecciona una respuesta'),
                    ),
                  );
                }
              }
            }),
        const SizedBox(height: AppSpacing.lg),
      ],
    ),
  );
}
