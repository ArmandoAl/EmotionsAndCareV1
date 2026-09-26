import '../../helpers/paths.dart';
import '../demo_data_store.dart';

/// Reemplazo en memoria de [IScheduleRepository] (módulo Agenda) para el
/// modo demo. Las acciones específicas del rol especialista no se usan en
/// el flujo de estudiante, así que se dejan como operaciones seguras sin
/// efecto.
class DemoScheduleRepository implements IScheduleRepository {
  @override
  Future<List<DateModel>> getSchedules(int isPatient) async {
    return List<DateModel>.from(DemoDataStore.dates);
  }

  @override
  Future<DateWithAchivement> addSchedule(
      int id, DateModel date, int idSpecialist) async {
    final int dateId = DemoDataStore.nextDateId;
    DemoDataStore.dates.add(date.copyWith(id: dateId));
    return DateWithAchivement(id: dateId);
  }

  @override
  Future<bool> updateSchedule(
      DateModel date, int patientId, int specialistId, bool isFromSpecialist) async {
    final int index = DemoDataStore.dates.indexWhere((e) => e.id == date.id);
    if (index != -1) {
      DemoDataStore.dates[index] = date;
    }
    return true;
  }

  @override
  Future<bool> updateStatusCita(DateModel date) async {
    final int index = DemoDataStore.dates.indexWhere((e) => e.id == date.id);
    if (index != -1) {
      DemoDataStore.dates[index] = date;
    }
    return true;
  }

  @override
  Future<bool> deleteSchedule(int dateId) async {
    DemoDataStore.dates.removeWhere((element) => element.id == dateId);
    return true;
  }

  @override
  Future<bool> confirmDateByPatient(int idDate, int idPatient) async => true;

  @override
  Future<bool> confirmDateBySpecialist(
      int idDate, int idSpecialist, int idPatient) async => true;

  @override
  Future<bool> cancelDateByPatient(int idDate, int idPatient) async => true;

  @override
  Future<bool> cancelDateBySpecialist(
      int idDate, int idSpecialist, int idPatient) async => true;

  @override
  Future<List<DateRequestModel>> getDatesRequest(int idSpecialist) async => [];

  @override
  Future<List<DateModel>> getDatesForSpecialist(int idSpecialist) async => [];

  @override
  Future<List<SpecialistModel>> getSpecialists(int offset) async {
    return List<SpecialistModel>.from(DemoDataStore.specialists);
  }

  @override
  Future<int> addDateBySpecialist(
      int idSpecialist, DateModel date, int idPatient) async => 0;

  @override
  Future<bool> rejectDate(int idSpecialist, int idDate) async => true;

  @override
  Future<bool> aceptDateBySpecialist(int idSpecialist, int idDate) async => true;
}
