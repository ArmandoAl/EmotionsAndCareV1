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
                Row(
                  children: [
                    const SizedBox(width: 15),
                    const Text(
                      "Logros",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
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
                        child: const Text("Ver todos")),
                    const SizedBox(width: 15),
                  ],
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
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              demoSvg(
                                url ?? '',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                achievements[index].achievement!.name!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                getDateFormatWithText(
                                    achievements[index].dateEarned!),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
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
                const SizedBox(height: 15),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    const Text(
                      "Stickers",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
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
                        child: const Text("Ver todos")),
                    const SizedBox(width: 15),
                  ],
                ),
                Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: uiCubit.state.stickers!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Center(
                          child: demoSvg(
                            uiCubit.state.stickers![index].url ?? '',
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
                const SizedBox(height: 15),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    const Text(
                      "Flores",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
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
                        child: const Text("Ver todos")),
                    const SizedBox(width: 15),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: uiCubit.state.flowers.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
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
                              const SizedBox(height: 10),
                              Text(
                                uiCubit.state.flowers[index].flower.name!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "Etapa ${uiCubit.state.flowers[index].state} / 6",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1,
                                  horizontal: 20,
                                ),
                                child: LinearProgressIndicator(
                                  value: uiCubit.state.flowers[index].state / 6,
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.green,
                                ),
                              ),
                              if (uiCubit.state.flowers[index].state == 6)
                                const Text("Activa",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
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
      backgroundColor: Colors.grey.withOpacity(0.85),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Detalle del logro",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              demoSvg(
                achivement.achievement!.imageUrl ?? '',
                height: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                achivement.achievement!.name!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                achivement.achievement!.description!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Conseguido el ${getDateFormatWithText(achivement.dateEarned!)}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
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
      backgroundColor: Colors.grey.withOpacity(0.85),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text("Detalle del sticker",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(height: 10),
              demoSvg(
                sticker.url ?? '',
                height: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    "Conseguido ${getDateFromUserSticker(pattient, sticker)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
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
      backgroundColor: Colors.grey.withOpacity(0.85),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Detalle de flor",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              demoSvg(
                flower.flower.urls![flower.state].url,
                height: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                flower.flower.name ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Etapa ${flower.state} / 6",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: flower.state / 6,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Conseguida el ${getDateFormatWithText(flower.createdAt ?? DateTime.now())}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (flower.state == 6)
                const Text("Flor activa",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
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
