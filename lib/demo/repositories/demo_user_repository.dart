import '../../helpers/paths.dart';
import '../demo_data_store.dart';

/// Reemplazo en memoria de [IUserRepository] para el modo demo.
///
/// El flujo de login/registro real nunca se muestra en la demo (ver el
/// atajo en `BegginCubit.getUser`), así que la mayoría de estos métodos
/// solo existen para satisfacer la interfaz de forma segura por si algún
/// widget los llega a invocar (por ejemplo, desde la pantalla de ajustes).
class DemoUserRepository implements IUserRepository {
  @override
  Future<dynamic> multiLogin(String email, String password) async {
    return DemoDataStore.patient;
  }

  @override
  Future<int> createPatient(PatientModel patient) async => 1;

  @override
  Future<int> createSpecialist(SpecialistModel specialist) async => 1;

  @override
  Future<void> setRegisterSet(int idPatient, String state) async {
    DemoDataStore.patient = DemoDataStore.patient.copyWith(registerStatus: state);
  }

  @override
  Future<void> changePrivacy(int patientId, bool notiActivated,
      bool dairyActivated, bool progressActivated) async {
    DemoDataStore.patient = DemoDataStore.patient.copyWith(
      settings: PattientSettings(
        id: DemoDataStore.patient.settings!.id,
        notifications: notiActivated,
        diaryActivated: dairyActivated,
        testActivated: progressActivated,
      ),
    );
  }

  @override
  Future<void> deletePatient(int patientiD) async {
    // No hay nada que borrar de verdad: la demo vive solo en memoria.
  }

  @override
  Future<bool> syncByCode(int patientId, String code) async => false;

  @override
  Future<bool> syncByDirectCode(int id, String code) async => false;

  @override
  Future<PatientModel> getPatient(int id) async => DemoDataStore.patient;

  @override
  Future<dynamic> refreshToken(int id, String token) async => DemoDataStore.patient;

  @override
  Future<bool> vincularPaciente(int specialistId, int patientId) async => false;

  @override
  Future<int> updatePatient(PatientModel patient) async {
    DemoDataStore.patient = patient;
    return 1;
  }

  @override
  Future<int> updateSpecialist(SpecialistModel specialist) async => 1;

  @override
  Future<bool> recoverPassword(String email) async => true;

  @override
  Future<bool> validateCode(String email, String code) async => true;

  @override
  Future<bool> changePassword(String email, String password) async => true;
}
