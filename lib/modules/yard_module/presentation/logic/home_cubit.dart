import '../../../../helpers/paths.dart';

class HomeCubit extends Cubit<HomeState> {
  final INotificationRepository repository;

  HomeCubit({required this.repository}) : super(const HomeState());

  Future<void> getNotification(int idPatient) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final notifications = await repository.getNotification(idPatient);
      emit(state.copyWith(
        items: [...state.items, notifications],
        status: HomeStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  Future<void> deleteNotification(int id) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final notifications = await repository.deleteNotification(id);

      if (notifications) {
        emit(state.copyWith(
          items: state.items.where((element) => element.id != id).toList(),
          status: HomeStatus.loaded,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  Future<void> getNotifications(int id) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      List<NotificationModel> notifications = await repository.init(id);

      emit(state.copyWith(
        items: notifications,
        status: HomeStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  void clean() {
    emit(const HomeState());
  }

  void changeNotificationCompleteStatud(
      int notificationId, int idRecomendation, int pattientId) {
    final notifications = state.items.map((e) {
      if (e.id == notificationId) {
        return e.copyWith(completed: !e.completed!);
      }
      return e;
    }).toList();

    emit(state.copyWith(items: notifications));

    repository.recomendationCompleted(idRecomendation, pattientId);
  }

  void deleteNotificationLocally(int idNotification) {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final List<NotificationModel> notifications =
          state.items.where((element) => element.id != idNotification).toList();

      emit(state.copyWith(
        items: notifications,
        status: HomeStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  void posone(int idNotification) {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      repository.posponeNote(idNotification);

      final List<NotificationModel> notifications =
          state.items.where((element) => element.id != idNotification).toList();

      emit(state.copyWith(
        items: notifications,
        status: HomeStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  void growStage(int id) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final response = await repository.growStage(id);

      if (response) {
        emit(state.copyWith(status: HomeStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  void canGrowStage(int id) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final response = await repository.canGrowStage(id);

      if (response) {
        emit(state.copyWith(status: HomeStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  void growFlowerinBack(int idPatient, int idUserFlower) async {
    emit(state.copyWith(status: HomeStatus.growing));
    try {
      await repository.growFlower(idPatient, idUserFlower);

      emit(state.copyWith(status: HomeStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  void changeStatus(
    HomeStatus status,
  ) {
    emit(state.copyWith(status: status));
  }
}
