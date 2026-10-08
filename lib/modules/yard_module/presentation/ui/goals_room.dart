import 'package:emotions_and_care_v1/modules/yard_module/presentation/ui/items_detail_screen.dart';
import '../../../../demo/widgets/demo_svg.dart';
import '../../../../helpers/paths.dart';

class GoalsRoom extends StatefulWidget {
  const GoalsRoom({
    super.key,
  });

  @override
  State<GoalsRoom> createState() => _GoalsRoomState();
}

class _GoalsRoomState extends State<GoalsRoom> {
  late UICubit uiCubit;
  late PatientModel? patient;

  @override
  void initState() {
    super.initState();
    uiCubit = getIt<UICubit>();
    patient = getIt<BegginCubit>().state.patientModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                AppSectionHeader(
                  title: "Logros",
                  actionLabel: "Ver todos",
                  onActionTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemsDetailScreen(
                            achivementItems: uiCubit.state.achievements
                                .where((ach) => ach.dateEarned != null)
                                .toList(),
                            title: "Logros",
                            onAchivementTap:
                                (UserAchievement achivement) async {
                              await showItemDetailDialogAchivement(
                                  context, achivement);
                            },
                            onStickerTap: (StickerModel sticker) async {},
                            stickersItems: const [],
                            flowers: const [],
                            onFlowerTap: (UserFlower flower) async {},
                          ),
                        ));
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: uiCubit.state.achievements
                        .where((ach) => ach.dateEarned != null)
                        .length,
                    itemBuilder: (context, index) {
                      final List<UserAchievement> achievements = uiCubit
                          .state.achievements
                          .where((ach) => ach.dateEarned != null)
                          .toList();
                      final url = achievements[index].achievement!.imageUrl;

                      return Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: const EdgeInsets.all(AppSpacing.sm),
                        child: AppCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              demoSvg(
                                url ?? '',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                achievements[index].achievement!.name!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                getDateFormatWithText(
                                    achievements[index].dateEarned!),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
            Flexible(
                child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                AppSectionHeader(
                  title: "Stickers",
                  actionLabel: "Ver todos",
                  onActionTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemsDetailScreen(
                            achivementItems: const [],
                            title: "Stickers",
                            onAchivementTap:
                                (UserAchievement achivement) async {},
                            onStickerTap: (StickerModel sticker) async {
                              await showItemDetailDialogSticker(
                                context,
                                sticker,
                                patient,
                              );
                            },
                            stickersItems: uiCubit.state.stickers ?? [],
                            flowers: const [],
                            onFlowerTap: (UserFlower flower) async {},
                          ),
                        ));
                  },
                ),
                Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: uiCubit.state.stickers!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        margin: const EdgeInsets.all(AppSpacing.sm),
                        child: AppCard(
                          child: Center(
                            child: demoSvg(
                              uiCubit.state.stickers![index].url ?? '',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                AppSectionHeader(
                  title: "Flores",
                  actionLabel: "Ver todos",
                  onActionTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemsDetailScreen(
                            achivementItems: const [],
                            title: "Flores",
                            onAchivementTap:
                                (UserAchievement achivement) async {},
                            onStickerTap: (StickerModel sticker) async {},
                            stickersItems: uiCubit.state.stickers ?? [],
                            flowers: uiCubit.state.flowers,
                            onFlowerTap: (UserFlower flower) async {
                              await showItemDetailDialogFlower(
                                  context, flower);
                            },
                          ),
                        ));
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: uiCubit.state.flowers.length,
                    itemBuilder: (context, index) {
                      final scheme = Theme.of(context).colorScheme;
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: const EdgeInsets.all(AppSpacing.sm),
                        child: AppCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              demoSvg(
                                uiCubit
                                    .state
                                    .flowers[index]
                                    .flower
                                    .urls![uiCubit.state.flowers[index].state]
                                    .url,
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                uiCubit.state.flowers[index].flower.name!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                "Etapa ${uiCubit.state.flowers[index].state} / 6",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  child: LinearProgressIndicator(
                                    value: uiCubit.state.flowers[index].state / 6,
                                    backgroundColor: scheme.primaryContainer,
                                    color: scheme.primary,
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              if (uiCubit.state.flowers[index].state == 6) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text("Activa",
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.w700,
                                        )),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

Future<void> showItemDetailDialogAchivement(
    BuildContext context, UserAchievement achivement) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      scrollable: true,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Detalle del logro", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              demoSvg(
                achivement.achievement!.imageUrl ?? '',
                height: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                achivement.achievement!.name!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                achivement.achievement!.description!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Conseguido el ${getDateFormatWithText(achivement.dateEarned!)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showItemDetailDialogSticker(
    BuildContext context, StickerModel sticker, PatientModel? pattient) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      scrollable: true,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Detalle del sticker", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              demoSvg(
                sticker.url ?? '',
                height: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Conseguido ${getDateFromUserSticker(pattient, sticker)}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showItemDetailDialogFlower(
    BuildContext context, UserFlower flower) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      scrollable: true,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Detalle de flor", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              demoSvg(
                flower.flower.urls![flower.state].url,
                height: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                flower.flower.name ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Etapa ${flower.state} / 6",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: flower.state / 6,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  color: Theme.of(context).colorScheme.primary,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Conseguida el ${getDateFormatWithText(flower.createdAt ?? DateTime.now())}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (flower.state == 6) ...[
                const SizedBox(height: AppSpacing.xs),
                Text("Flor activa",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        )),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

String getDateFromUserSticker(PatientModel? patient, StickerModel sticker) {
  if (patient == null) {
    return '';
  }

  final date = patient.userInterface!.userStickers!
      .firstWhere((element) => element.sticker.id == sticker.id)
      .createdAt;
  return getDateFormatWithText(date ?? DateTime.now());
}
