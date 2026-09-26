import '../../../../helpers/paths.dart';

class PattientsDatesCubit extends Cubit<PattientsDatesState> {
  final IScheduleRepository _repository;

  PattientsDatesCubit({required IScheduleRepository repository})
      : _repository = repository,
        super(const PattientsDatesState());

  Future<void> getPattientsDates(int idUser) async {
    emit(state.copyWith(status: PattientsDatesStatus.loading));
    try {
      List<DateRequestModel> dates = await _repository.getDatesRequest(idUser);

      emit(state.copyWith(status: PattientsDatesStatus.loaded, dates: dates));
    } catch (e) {
      emit(state.copyWith(status: PattientsDatesStatus.error));
    }
  }

  Future<void> rejectDate(int idSpecialist, int idDate) async {
    emit(state.copyWith(status: PattientsDatesStatus.loading));
    try {
      bool res = await _repository.rejectDate(idSpecialist, idDate);

      if (res) {
        List<DateRequestModel> dates = state.dates
            .where((element) => element.date!.id! != idDate)
            .toList();

        emit(state.copyWith(
          dates: dates,
          status: PattientsDatesStatus.loaded,
        ));
      } else {
        emit(state.copyWith(status: PattientsDatesStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: PattientsDatesStatus.error));
    }
  }

  Future<bool> aceptDateBySpecialist(int idSpecialist, int idDate) async {
    emit(state.copyWith(status: PattientsDatesStatus.loading));
    try {
      bool res = await _repository.aceptDateBySpecialist(idSpecialist, idDate);

      if (res) {
        final List<DateRequestModel> dates = state.dates
            .where((element) => element.date!.id! != idDate)
            .toList();

        emit(state.copyWith(
          dates: dates,
          status: PattientsDatesStatus.loaded,
        ));
      } else {
        emit(state.copyWith(status: PattientsDatesStatus.error));
      }

      return res;
    } catch (e) {
      emit(state.copyWith(status: PattientsDatesStatus.error));
      return false;
    }
  }

  void clean() {
    emit(const PattientsDatesState());
  }
}
