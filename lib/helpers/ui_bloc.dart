// ignore_for_file: deprecated_member_use
import 'package:emotions_and_care_v1/modules/auth_module/domain/progress.dart';
import 'package:equatable/equatable.dart';
import '../../helpers/paths.dart';

class UICubit extends Cubit<UIState> {
  final StorageRepository storageRepository;
  final UIRepository uiRepoitory;

  UICubit({
    required this.storageRepository,
    required this.uiRepoitory,
  }) : super(const UIState());

  void setUpUI() async {
    int? selectedTheme = await storageRepository.getSelectedTheme();
    selectedTheme ??= 0;

    List<ThemeData> themes = [
      // 🌊 Tema Azul (Principal)
      ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue[50]!,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Color(0xFF2CB5E0),
          surface: Color(0xFFE3EDF3),
          onSecondary: Colors.black,
          onPrimary: Colors.white,
          onSurface: Colors.black,
          //this color C5F1FF
          onPrimaryContainer: Color(0xFFB7E1FF),
          //THIS COLOR F3E7D6
          onSecondaryContainer: Color(0xFFF3E7D6),
        ),
        scaffoldBackgroundColor: const Color(0xFFE3EDF3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE3EDF3),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Color(0xFFE3EDF3),
          iconColor: Colors.black,
          surfaceTintColor: Colors.black,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFFE3EDF3),
          surfaceTintColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color(0xFF2CB5E0),
            ),
            surfaceTintColor: MaterialStateProperty.all(
              Colors.black,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2CB5E0),
          foregroundColor: Colors.black,
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFFE3EDF3)),
            surfaceTintColor: WidgetStatePropertyAll(Colors.black),
          ),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.blueGrey),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Gilroy',
          ),
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Gilroy',
          ),
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // 🌙 Tema Oscuro
      ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.greenAccent,
          surface: Colors.grey[900]!,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey[900],
          iconColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.grey[900],
          surfaceTintColor: Colors.white,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.grey),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.grey[900]),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Gilroy',
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Gilroy',
          ),
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    String? selectedBackground =
        await storageRepository.getSelectedBackground();

    selectedBackground ??= Assets.backgroundstatic_1;

    final List<AppText> texts = await uiRepoitory.getTexts();

    setTextFromBack(texts);

    emit(state.copyWith(
      isDarkMode: false,
      themes: themes,
      currentFlower: null,
      flowers: [UserFlower(userFlowerId: 0, flower: FlowerModel(), state: 0)],
      stickers: List.generate(4, (index) => StickerModel.empty()),
      stickersInUse: List.generate(4, (index) => StickerModel.empty()),
      selectedBackground: selectedBackground,
      selectedTheme: selectedTheme,
    ));
  }

  List<StickerModel> getStickersForUI(List<UserSticker> userStickers) {
    // Lista de 4 espacios para los stickers en la UI, inicializados como vacíos
    List<StickerModel?> stickerSlots = List.filled(4, null);

    // Colocar los stickers en sus posiciones correspondientes
    for (var userSticker in userStickers) {
      if (userSticker.position != null) {
        int index = userSticker.position! -
            1; // Convertir posición a índice de UI (0-based)
        if (index >= 0 && index < 4) {
          stickerSlots[index] = userSticker.sticker;
        }
      }
    }

    // Reemplazar los espacios vacíos con stickers vacíos
    return stickerSlots.map((e) => e ?? StickerModel.empty()).toList();
  }

  void setTextFromBack(List<AppText> texts) {
    final List<AppText> textsFromApi = texts;
    final Map<String, AppText> textsMap = convertListToMap(textsFromApi);

    emit(state.copyWith(texts: textsMap));
  }

  void setBackAssets(
      List<UserSticker>? userStickers,
      List<UserFlower>? userFlowers,
      List<UserAchievement>? userAchievements,
      int selectedTheme,
      int selectedBackgroundIndex) {
    emit(state.copyWith(
      status: UIStatus.loading,
    ));
    if (userStickers == null) return;

    //si las nuevas flores son menos de 4 , se rellenan con flores vacias

    //busca la flor que tenga la posicion 1, si no la encuentra, asignas null
    UserFlower? currentFlower =
        userFlowers!.firstWhere((element) => element.position == 2, orElse: () {
      return UserFlower(userFlowerId: -1, flower: FlowerModel(), state: 0);
    });

    final List<String> backgrounds = [
      Assets.yardBackgroundLottieAnimation,
      Assets.starBackgroundLottieAnimation,
    ];

    int newSelectedBackgroundIndex =
        selectedBackgroundIndex > 1 ? selectedBackgroundIndex : 1;

    final String selectedBackground =
        backgrounds[newSelectedBackgroundIndex - 1];

    emit(state.copyWith(
        stickers: userStickers.map((e) => e.sticker).toList(),
        stickersInUse: getStickersForUI(userStickers),
        flowers: userFlowers,
        currentFlower: currentFlower.userFlowerId == -1 ? null : currentFlower,
        selectedTheme: selectedTheme,
        selectedBackground: selectedBackground,
        achievements: userAchievements,
        status: UIStatus.success));
  }

  Future<void> getFlowerProgress(int idpatient) async {
    final List<ProgressInfo> flowerProgress =
        await uiRepoitory.getStagesProgress(idpatient);
    emit(state.copyWith(flowerProgress: flowerProgress));
  }

  Achievement? getAchivement(int achivementId) {
    UserAchievement? userAchievement = state.achievements.firstWhere(
        (element) => element.achievementId == achivementId,
        orElse: () => UserAchievement());

    if (userAchievement.userAchievementId == null) {
      return null;
    }

    if (userAchievement.achievement == null) {
      return null;
    }

    Achievement achievement = userAchievement.achievement!;

    if (userAchievement.dateEarned != null) {
      return null;
    }
    if (userAchievement.progress == null) {
      return null;
    }

    return achievement;
  }

  void addAchivementToUser(Achievement achivement) {
    List<UserAchievement> achievements = state.achievements.map((e) {
      if (e.achievementId == achivement.achievementId) {
        return e.copyWith(
          // progress: e.progress! + 1,
          dateEarned: DateTime.now(),
        );
      }
      return e;
    }).toList();

    emit(state.copyWith(achievements: achievements, status: UIStatus.success));
  }

  void growFlowerStage() {
    //encuentra la flor que tenga la posicion 1
    UserFlower? currentFlower = state.currentFlower;

    if (currentFlower == null) {
      return;
    }

    currentFlower = currentFlower.copyWith(state: currentFlower.state + 1);

    List<UserFlower> flowers = state.flowers.map((e) {
      if (e.userFlowerId == currentFlower!.userFlowerId) {
        return currentFlower;
      }
      return e;
    }).toList();

    emit(state.copyWith(flowers: flowers, currentFlower: currentFlower));
  }

  void changeStatus(UIStatus status) {
    emit(state.copyWith(status: status));
  }

  void changeDarkMode(bool isDarkMode) {
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  void setTheme(int idpatient, int index) {
    storageRepository.saveSelectedTheme(index);

    uiRepoitory.setTheme(idpatient, index);

    emit(state.copyWith(selectedTheme: index));
  }

  void setSelectedBackground(
    int idpatient,
    String background,
    int index,
  ) {
    storageRepository.saveSelectedBackground(background);
    uiRepoitory.setSelectedBackground(idpatient, index);

    emit(state.copyWith(selectedBackground: background));
  }

  void setCurrentFlower(UserFlower flower) {
    //storageRepository.saveCurrentFlower(flower);
    emit(state.copyWith(currentFlower: flower));
  }

  void addFlower(UserFlower flower) {
    final List<UserFlower> flowers = state.flowers;
    flowers.add(flower);
    emit(state.copyWith(flowers: flowers));
  }

  void setFlowerInInterface(int idpatient, UserFlower flower, int position) {
    // Primero emitimos el estado loading
    emit(state.copyWith(status: UIStatus.loading));

    List<UserFlower> flowers = state.flowers.map((e) {
      if (e.position == position) {
        return flower.copyWith(position: null);
      }
      return e;
    }).toList();

    //ahora que hicimos que la flor que ya tenia esa posicion la tuviera de nuevo en 0, debemos asignarle la posicion a la nueva flor

    // Emitimos el cambio antes de la llamada al repositorio
    emit(state.copyWith(
        currentFlower: flower, flowers: flowers, status: UIStatus.success));

    // Hacemos la llamada al repositorio después
    uiRepoitory.setFlowerInInterface(idpatient, flower, position + 1);
  }

  void removeSticker(int idPatient, int position) async {
    if (position < 1 || position > 4) {
      return;
    }

    try {
      // Find the index in the stickersInUse list (0-based)
      int index = position - 1;

      // Create a copy of the current stickersInUse list
      List<StickerModel> updatedStickers = List.from(state.stickersInUse);

      // Replace the sticker at the specified position with an empty one
      updatedStickers[index] = StickerModel.empty();

      // Update the database if needed
      uiRepoitory.removeSticker(
        idPatient,
        state.stickersInUse[index],
        position,
      );

      // Emit the updated state
      emit(state.copyWith(
        stickersInUse: updatedStickers,
        status: UIStatus.success,
      ));
    } catch (e) {
      // Handle any errors

      emit(state.copyWith(
        status: UIStatus.error,
        //errorMessage: "Failed to remove sticker: ${e.toString()}",
      ));
    }
  }

  void setStickerInUse(int idpatient, StickerModel sticker, int index) {
    // Primero emitimos el estado loading
    emit(state.copyWith(status: UIStatus.loading));

    List<StickerModel> stickersInUse = List.from(state.stickersInUse);

    if (stickersInUse.contains(sticker)) {
      int existingIndex =
          stickersInUse.indexWhere((element) => element == sticker);
      stickersInUse[existingIndex] = StickerModel.empty();
      stickersInUse[index] = sticker;
    } else {
      stickersInUse[index] = sticker;
    }

    // Emitimos el cambio antes de la llamada al repositorio
    emit(
        state.copyWith(stickersInUse: stickersInUse, status: UIStatus.success));

    // Hacemos la llamada al repositorio después
    uiRepoitory.setStickerInInterface(idpatient, sticker, index + 1);
  }

  void addSticker(StickerModel sticker) {
    final List<StickerModel> stickers = state.stickers!;

    //revisa si el sticker ya esta en la lista de stickers
    if (stickers.contains(sticker)) {
      return;
    }

    stickers.add(sticker);
    emit(state.copyWith(stickers: stickers));
  }

  void setStickers(List<StickerModel> stickers) {
    emit(state.copyWith(stickers: stickers));
  }

  void toggleTheme() {
    final bool isDarkMode = !state.isDarkMode;
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> getSticker(int id) async {
    final StickerModel sticker = await uiRepoitory.getSticker(id);
    final List<StickerModel> stickers = state.stickers!;
    stickers.add(sticker);
    storageRepository.saveStickers(stickers);
    emit(state.copyWith(stickers: stickers));
  }

  Future<void> clean() async {
    emit(const UIState());
    setUpUI();
  }
}

enum UIStatus { start, login, register, loading, error, success }

class UIState extends Equatable {
  final UIStatus status;
  final bool isDarkMode;
  final UserFlower? currentFlower;
  final List<UserFlower> flowers;
  final List<UserAchievement> achievements;
  final List<StickerModel>? stickers;
  final String selectedBackground;
  final int selectedTheme;
  final List<ThemeData> themes;
  final List<StickerModel> stickersInUse;
  final Map<String, AppText> texts;
  final List<ProgressInfo> flowerProgress;

  const UIState({
    this.status = UIStatus.start,
    this.isDarkMode = false,
    this.currentFlower,
    this.flowers = const [],
    this.stickers = const [],
    this.achievements = const [],
    this.selectedBackground = Assets.backgroundstatic_1,
    this.selectedTheme = 0,
    this.themes = const [],
    this.stickersInUse = const [],
    this.texts = const {},
    this.flowerProgress = const [],
  });

  UIState copyWith({
    UIStatus? status,
    bool? isDarkMode,
    UserFlower? currentFlower,
    List<UserFlower>? flowers,
    List<StickerModel>? stickers,
    List<UserAchievement>? achievements,
    String? selectedBackground,
    int? selectedTheme,
    List<ThemeData>? themes,
    List<StickerModel>? stickersInUse,
    Map<String, AppText>? texts,
    List<ProgressInfo>? flowerProgress,
  }) {
    return UIState(
      status: status ?? this.status,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentFlower: currentFlower ?? this.currentFlower,
      flowers: flowers ?? this.flowers,
      stickers: stickers ?? this.stickers,
      achievements: achievements ?? this.achievements,
      selectedBackground: selectedBackground ?? this.selectedBackground,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      themes: themes ?? this.themes,
      stickersInUse: stickersInUse ?? this.stickersInUse,
      texts: texts ?? this.texts,
      flowerProgress: flowerProgress ?? this.flowerProgress,
    );
  }

  @override
  List<Object> get props => [
        status,
        isDarkMode,
        currentFlower ?? FlowerModel(),
        flowers,
        stickers ?? [],
        achievements,
        selectedBackground,
        selectedTheme,
        themes,
        stickersInUse,
        texts,
        flowerProgress,
      ];
}

class AppText {
  final int textId;
  final String text;
  final int textType;
  final DateTime dateCreated;
  final DateTime modifiedDate;

  AppText({
    required this.textId,
    required this.text,
    required this.textType,
    required this.dateCreated,
    required this.modifiedDate,
  });

  factory AppText.fromJson(Map<String, dynamic> json) {
    return AppText(
      textId: json['textId'] as int,
      text: json['text'] as String,
      textType: json['textType'] as int,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textId': textId,
      'text': text,
      'textType': textType,
      'dateCreated': dateCreated.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
    };
  }

  List<String> get paragraphs => text.split('||');
}

Map<String, AppText> convertListToMap(List<AppText> list) {
  return {for (var item in list) item.textId.toString(): item};
}
