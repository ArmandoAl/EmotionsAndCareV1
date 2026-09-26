import '../helpers/paths.dart';
import '../modules/test_module/presentation/utils/test_module_strings.dart';

Widget intructionsWidget(
    BuildContext context, TestModel test, PageController pageController) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.sm,
    ),
    child: ListView(
      children: [
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 26),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(test.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: AppColors.shadowWarm)),
        const SizedBox(height: AppSpacing.lg),
        Text(test.instructions,
            textAlign: TextAlign.justify,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.shadowWarm)),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: 'Empezar cuestionario',
          expand: true,
          onPressed: () {
            //change page
            pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
          },
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    ),
  );
}

Widget testResultWidget(
  BuildContext context,
  TestInfoModel test,
  PageController pageController,
  int userId,
  String? result,
  BegginCubit userProvider,
  Achievement? goal,
) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.28,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Icon(
          Icons.check_circle_rounded,
          size: MediaQuery.of(context).size.width * 0.2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      Expanded(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Text(testResult1String,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.shadowWarm)),
                const SizedBox(height: AppSpacing.sm),
                Text(result!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.shadowWarm,
                        )),
                const SizedBox(height: AppSpacing.lg),
                Text(dynamicResulTest[result] ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.shadowWarm)),
                const SizedBox(height: AppSpacing.lg),
                Text(testResult2String,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7))),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ),
      )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: AppButton(
          label: 'Continuar',
          expand: true,
          onPressed: () async {
            if (goal != null) {
              await showStickerDialog(context, goal);
            }

            if (userProvider.state.registerPatientFlow == "register") {
              userProvider.setRegisterFlow(
                  userProvider.state.patientModel!.id!, "firstTestCompleted");
            }

            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ),
      const SizedBox(height: AppSpacing.xxl),
    ],
  );
}
