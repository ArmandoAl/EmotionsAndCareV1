import '../../../../helpers/paths.dart';

class TestHistoryItemsScreen extends StatefulWidget {
  final HistoryTestModel test;
  final Function(TestInfoModel) onTap;
  const TestHistoryItemsScreen(
      {super.key, required this.test, required this.onTap});

  @override
  State<TestHistoryItemsScreen> createState() => _TestHistoryItemsScreenState();
}

class _TestHistoryItemsScreenState extends State<TestHistoryItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(
        title: widget.test.name,
        isForReturn: true,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ListView.builder(
            itemCount: widget.test.testInfoList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  testHistoryItem(
                    context,
                    widget.test.testInfoList[index],
                    widget.onTap,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              );
            },
          )),
    );
  }
}

Widget testHistoryItem(
  BuildContext context,
  TestInfoModel testInfo,
  Function(TestInfoModel) onTap,
) {
  final Color background = testHistoryColors[testInfo.resultado]!;
  return AppCard(
    onTap: () => onTap(testInfo),
    color: background.withOpacity(0.18),
    padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    child: Row(
      children: [
        Container(
          width: 10,
          height: 40,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(testInfo.resultado,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.shadowWarm)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "${testInfo.date.day}/${testInfo.date.month}/${testInfo.date.year}",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.shadowWarm.withOpacity(0.7)),
            ),
          ],
        ),
        const Spacer(),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.shadowWarm.withOpacity(0.5),
          size: 16,
        )
      ],
    ),
  );
}
