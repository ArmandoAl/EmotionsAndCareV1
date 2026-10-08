import '../helpers/paths.dart';

Widget testItem(BuildContext context, HistoryTestModel test,
    Function(TestInfoModel) onTap) {
  return Container(
    margin: const EdgeInsets.all(AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.sm),
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.25,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                startFrom(test.name, "("),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.shadowWarm),
              ),
            ),
            Text(
              "Últimos resultados",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                test.testInfoList.length > 5 ? 5 : test.testInfoList.length,
            itemBuilder: (context, index) {
              final Color background =
                  testHistoryColors[test.testInfoList[index].resultado]!;
              return GestureDetector(
                onTap: () {
                  onTap(test.testInfoList[index]);
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: background.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: background, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                      margin: const EdgeInsets.all(AppSpacing.xs),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(test.testInfoList[index].resultado,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: AppColors.shadowWarm)),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            "${test.testInfoList[index].date.day}/${test.testInfoList[index].date.month}/${test.testInfoList[index].date.year}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.shadowWarm.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          width: 5,
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          )),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
