import '../../../../helpers/paths.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final IScheduleRepository repository;
  ScheduleCubit({required this.repository}) : super(const ScheduleState());
  //Add date to the list
  Future<DateWithAchivement> addDate(
      int idPatient, DateModel date, int idSpecialist) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final DateWithAchivement res =
          await repository.addSchedule(idPatient, date, idSpecialist);

      date = date.copyWith(id: res.id);

      emit(state.copyWith(
        dates: [...state.dates, date],
        status: ScheduleStatus.loaded,
      ));

      return res;
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
      throw Exception('Failed to add date');
    }
  }

  Future<bool> updateDate(DateModel date, int patientId, int specialistId,
      bool isFromSpecialist) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await repository.updateSchedule(
          date, patientId, specialistId, isFromSpecialist);
      final List<DateModel> dates = state.dates;
      final int index = dates.indexWhere((element) => element.id == date.id);
      dates[index] = date;
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
      return false;
    }
  }

  Future<bool> updateDateStatus(DateModel date) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await repository.updateStatusCita(date);
      final List<DateModel> dates = state.dates;
      final int index = dates.indexWhere((element) => element.id == date.id);
      dates[index] = date;
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
      return false;
    }
  }

  //delete date from the list
  Future<void> deleteDate(int idDate) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await repository.deleteSchedule(idDate);
      final List<DateModel> dates = state.dates;
      dates.removeWhere((element) => element.id == idDate);
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  //Confirm date by patient
  Future<void> confirmDateByPatient(DateModel date, int idPatient) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await repository.confirmDateByPatient(date.id!, idPatient);
      final List<DateModel> dates = state.dates;
      final int index = dates.indexWhere((element) => element.id == date.id);
      dates[index] = date;
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  //Confirm date by espetialist
  Future<void> confirmDateByEspetialist(
      int idDate, int idEspetialist, int idPatient) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await repository.cancelDateBySpecialist(idDate, idEspetialist, idPatient);
      final List<DateModel> dates = state.dates;
      final int index = dates.indexWhere((element) => element.id == idDate);
      dates[index] = dates[index].copyWith(confirmByEspetialist: true);
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  //cancel date by patient
  Future<void> cancelDateByPatient(int idDate, int idPatient) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await repository.cancelDateByPatient(idDate, idPatient);
      final List<DateModel> dates = state.dates;
      final int index = dates.indexWhere((element) => element.id == idDate);
      dates[index] = dates[index].copyWith(confirmByPatient: false);
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  //cancel date by espetialist
  Future<void> cancelDateByEspetialist(
      int idDate, int idEspetialist, int idPatient) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await repository.cancelDateBySpecialist(idDate, idEspetialist, idPatient);
      final List<DateModel> dates = state.dates;
      final int index = dates.indexWhere((element) => element.id == idDate);
      dates[index] = dates[index].copyWith(confirmByEspetialist: false);
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  Future<void> getSchedule(int patientId, {bool reloading = false}) async {
    emit(state.copyWith(
        status: reloading ? ScheduleStatus.reloading : ScheduleStatus.loading));
    try {
      final List<DateModel> dates = await repository.getSchedules(patientId);
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  Future<void> getDatesForSpecialist(int id, {bool reloading = false}) async {
    emit(state.copyWith(
        status: reloading ? ScheduleStatus.reloading : ScheduleStatus.loading));
    try {
      final List<DateModel> dates = await repository.getDatesForSpecialist(id);
      emit(state.copyWith(
        dates: dates,
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  Future<void> addDateBySpecialist(
      int idSpecialist, DateModel date, PatientModel patient) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final int resId =
          await repository.addDateBySpecialist(idSpecialist, date, patient.id!);
      date = date.copyWith(id: resId, patient: patient);
      emit(state.copyWith(
        dates: [...state.dates, date],
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  Future<void> getSpecialists() async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final List<SpecialistModel> specialists =
          await repository.getSpecialists(state.offset);
      emit(state.copyWith(
        specialists: specialists,
        auxiliar: specialists,
        offset: 0,
        isTheTotal: false,
        status: ScheduleStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  void searchSpecialisInTime(String value) {
    final List<SpecialistModel> specialists = state.auxiliar;
    final List<SpecialistModel> result = [];
    for (final SpecialistModel specialist in specialists) {
      if (specialist.name!.toLowerCase().contains(value.toLowerCase())) {
        result.add(specialist);
      }
    }
    emit(state.copyWith(specialists: result));
  }

  void clean() {
    emit(const ScheduleState());
  }

  void addFilter(String key, dynamic value) {
    // Create a new map by copying all entries from the current filters
    final Map<String, dynamic> newFilters =
        Map<String, dynamic>.from(state.filters);

    // Now you can safely modify the new map
    if (value == null) {
      newFilters.remove(key);
    } else {
      newFilters[key] = value;
    }

    // Emit the state with the new filters map
    emit(state.copyWith(filters: newFilters, status: ScheduleStatus.loaded));
  }

  void clearFilters() {
    emit(state.copyWith(
        specialists: state.auxiliar,
        filters: {},
        status: ScheduleStatus.loaded));
  }

  void filterSpecialist(Map<String, dynamic> filters) {
    // Start with all specialists
    final List<SpecialistModel> specialists = state.auxiliar;
    final List<SpecialistModel> result = [];

    // Process each specialist
    for (final SpecialistModel specialist in specialists) {
      bool matchesAllFilters = true;

      // Apply sex filter if present
      if (filters.containsKey("sexo") && filters["sexo"] != null) {
        if (specialist.sex != filters["sexo"]) {
          matchesAllFilters = false;
        }
      }

      // Apply age filter if present
      if (filters.containsKey("edad") && filters["edad"] != null) {
        String ageRange = filters["edad"];
        int? specialistAge = specialist.age;

        if (specialistAge != null) {
          if (ageRange == "20-30" &&
              (specialistAge < 20 || specialistAge > 30)) {
            matchesAllFilters = false;
          } else if (ageRange == "30-45" &&
              (specialistAge < 30 || specialistAge > 45)) {
            matchesAllFilters = false;
          } else if (ageRange == "45-100" && specialistAge < 45) {
            matchesAllFilters = false;
          }
        }
      }

      // Apply specialty filter if present
      if (filters.containsKey("especialidad") &&
          filters["especialidad"] != null) {
        // Assuming the focus field of SpecialistModel contains the specialty
        if (specialist.focus != filters["especialidad"]) {
          matchesAllFilters = false;
        }
      }

      // Apply name filter if present
      if (filters.containsKey("name") &&
          filters["name"] != null &&
          filters["name"].toString().isNotEmpty) {
        if (!specialist.name!
            .toLowerCase()
            .contains(filters["name"].toString().toLowerCase())) {
          matchesAllFilters = false;
        }
      }

      // If all filters match, add to result
      if (matchesAllFilters) {
        result.add(specialist);
      }
    }

    // Update state with filtered specialists
    emit(state.copyWith(specialists: result));
  }
}
