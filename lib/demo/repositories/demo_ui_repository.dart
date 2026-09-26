import '../../helpers/paths.dart';
import '../../modules/auth_module/domain/progress.dart';
import '../demo_data_store.dart';

/// Reemplazo en memoria de [UIRepository] (personalización del jardín) para
/// el modo demo. Todo lo visual ya se actualiza de forma optimista en
/// [UICubit], así que estos métodos son operaciones locales sin red.
class DemoUIRepository implements UIRepository {
  @override
  Future<StickerModel> getSticker(int id) async {
    return StickerModel(id: id, url: '');
  }

  @override
  Future<void> setStickerInInterface(
      int idpatient, StickerModel sticker, int index) async {}

  @override
  Future<void> setFlowerInInterface(
      int idpatient, UserFlower flower, int position) async {}

  @override
  Future<void> removeSticker(
      int idpatient, StickerModel sticker, int position) async {}

  @override
  Future<void> setTheme(int idpatient, int theme) async {}

  @override
  Future<void> setSelectedBackground(int idpatient, int background) async {}

  @override
  Future<List<AppText>> getTexts() async => [];

  @override
  Future<List<ProgressInfo>> getStagesProgress(int idpatient) async {
    return [
      ProgressInfo(
        name: 'diario',
        currentValue: DemoDataStore.notes.length,
        targetValue: 3,
        description: 'Escribe notas en tu diario',
        isCompleted: DemoDataStore.notes.length >= 3,
      ),
      ProgressInfo(
        name: 'cuestionarios',
        currentValue: DemoDataStore.completedTests.length,
        targetValue: 1,
        description: 'Completa un cuestionario de bienestar',
        isCompleted: DemoDataStore.completedTests.isNotEmpty,
      ),
      ProgressInfo(
        name: 'comunidad',
        currentValue: DemoDataStore.myCarts.length,
        targetValue: 1,
        description: 'Comparte un mensaje con la comunidad',
        isCompleted: DemoDataStore.myCarts.isNotEmpty,
      ),
    ];
  }
}
