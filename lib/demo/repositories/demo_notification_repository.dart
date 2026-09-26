import '../../helpers/paths.dart';
import '../demo_data_store.dart';

/// Reemplazo en memoria de [INotificationRepository] (módulo Jardín) para
/// el modo demo.
class DemoNotificationRepository implements INotificationRepository {
  @override
  Future<bool> deleteNotification(int id) async {
    DemoDataStore.notifications.removeWhere((element) => element.id == id);
    return true;
  }

  @override
  Future<NotificationModel> getNotification(int id) async {
    return DemoDataStore.notifications.firstWhere(
      (element) => element.id == id,
      orElse: () => NotificationModel(
        id: id,
        title: 'Demo',
        type: NotificationType.notificacionNota,
        description: 'Notificación de demostración.',
      ),
    );
  }

  @override
  Future<List<NotificationModel>> init(int id) async {
    return List<NotificationModel>.from(DemoDataStore.notifications);
  }

  @override
  Future<bool> growStage(int id) async => true;

  @override
  Future<bool> growFlower(int idPatient, int idUserFlower) async => true;

  @override
  Future<bool> canGrowStage(int idPatient) async => true;

  @override
  Future<bool> recomendationCompleted(int idRecomendacion, int idPatient) async {
    return true;
  }

  @override
  Future<bool> posponeNote(int idNote) async {
    DemoDataStore.notifications.removeWhere((element) => element.id == idNote);
    return true;
  }
}
