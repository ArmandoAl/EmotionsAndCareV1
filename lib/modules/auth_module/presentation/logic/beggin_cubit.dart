import 'dart:convert';
import '../../../../demo/demo_config.dart';
import '../../../../demo/demo_data_store.dart';
import '../../../../helpers/paths.dart';

enum RegisterSpecialistFlow { registerSuccess, licenseValidated }

class BegginCubit extends Cubit<BegginState> {
  final StorageRepository storageRepository;
  final IUserRepository userRepoitory;

  BegginCubit({
    required this.storageRepository,
    required this.userRepoitory,
  }) : super(const BegginState());

  Future<String> multiLogin(String email, String password,
      [bool isRememberPassword = false]) async {
    emit(state.copyWith(status: BegginStatus.loading));

    final response = await userRepoitory.multiLogin(email, password);

    if (response == null) {
      emit(state.copyWith(status: BegginStatus.error));
      return 'error';
    }

    if (response is String) {
      emit(state.copyWith(status: BegginStatus.error));
      return response;
    }

    if (response is PatientModel) {
      PatientModel patientModel = response;

      if (isRememberPassword) {
        storageRepository.savePatient(response);
      }

      emit(state.copyWith(
        status: BegginStatus.success,
        patientModel: response,
        isPatient: true,
        registerPatientFlow: patientModel.registerStatus,
        user: true,
      ));

      refreshToken(patientModel.id!);

      return 'success';
    } else {
      SpecialistModel specialistModel = response;

      if (isRememberPassword) {
        storageRepository.saveSpecialist(specialistModel);
      }

      refreshToken(specialistModel.id!);

      emit(state.copyWith(
        status: BegginStatus.loged,
        specialistModel: response,
        isPatient: false,
        user: true,
      ));

      return 'success';
    }
  }

  Future<String> updatePatientData(PatientModel patientModel) async {
    emit(state.copyWith(status: BegginStatus.updating));

    final response = await userRepoitory.updatePatient(patientModel);

    if (response == 0) {
      emit(state.copyWith(status: BegginStatus.error));
      return "Hubo un error al actualizar los datos";
    }

    if (response == -1) {
      emit(state.copyWith(status: BegginStatus.error));
      return "El correo ya está registrado";
    }

    if (response == -2) {
      return "El teléfono ya está registrado";
    }

    storageRepository.savePatient(patientModel);

    emit(state.copyWith(
      status: BegginStatus.success,
      patientModel: patientModel,
    ));

    return 'success';
  }

  Future<String> updateSpecialistData(SpecialistModel specialistModel) async {
    emit(state.copyWith(status: BegginStatus.updating));

    final response = await userRepoitory.updateSpecialist(specialistModel);

    if (response == 0) {
      emit(state.copyWith(status: BegginStatus.error));
      return "Hubo un error al actualizar los datos";
    }

    if (response == -1) {
      emit(state.copyWith(status: BegginStatus.error));
      return "El correo ya está registrado";
    }

    if (response == -2) {
      return "El teléfono ya está registrado";
    }

    if (response == -3) {
      return "La licencia ya está registrada";
    }

    storageRepository.saveSpecialist(specialistModel);

    emit(state.copyWith(
      status: BegginStatus.success,
      specialistModel: specialistModel,
    ));

    return 'success';
  }

  Future<bool> reloginPatient(PatientModel patient) async {
    emit(state.copyWith(status: BegginStatus.relogin));

    PatientModel user = await userRepoitory.getPatient(patient.id!);

    emit(state.copyWith(
      status: BegginStatus.success,
      patientModel: user,
      isPatient: true,
      registerPatientFlow: patient.registerStatus,
      user: true,
    ));

    refreshToken(patient.id!);

    return true;
  }

  // Future<bool> reloginSpecialist(SpecialistModel specialist) async {
  //   emit(state.copyWith(status: BegginStatus.relogin));

  //   SpecialistModel user = await userRepoitory.getSpecialist(specialist.id!);

  //   emit(state.copyWith(
  //     status: BegginStatus.success,
  //     specialistModel: user,
  //     isPatient: false,
  //     user: true,
  //   ));

  //   refreshToken(specialist.id!);

  //   return true;
  // }

  Future<bool> recoverPassword(String email) async {
    emit(state.copyWith(status: BegginStatus.loading));

    final response = await userRepoitory.recoverPassword(email);

    if (response == false) {
      emit(state.copyWith(status: BegginStatus.errorInRegister));
      return false;
    }

    if (response is String) {
      emit(state.copyWith(status: BegginStatus.errorInRegister));
      return false;
    }

    return true;
  }

  Future<bool> changePassword(String email, String newPassword) async {
    emit(state.copyWith(status: BegginStatus.loading));

    final response = await userRepoitory.changePassword(email, newPassword);

    if (response == false) {
      emit(state.copyWith(status: BegginStatus.errorInRegister));
      return false;
    }

    return true;
  }

  //validateCode
  Future<bool> validateCode(String email, String code) async {
    emit(state.copyWith(status: BegginStatus.loading));

    final response = await userRepoitory.validateCode(email, code);

    if (response == false) {
      emit(state.copyWith(status: BegginStatus.errorInRegister));
      return false;
    }

    return true;
  }

  Future<void> getUser() async {
    emit(state.copyWith(status: BegginStatus.loading));

    if (kDemoMode) {
      // Modo demo: entra directo como un estudiante de ejemplo, sin login,
      // sin leer almacenamiento local y sin llamar a ningún backend.
      emit(state.copyWith(
        status: BegginStatus.success,
        patientModel: DemoDataStore.patient,
        isPatient: true,
        user: true,
        registerPatientFlow: 'registerSuccess',
      ));
      return;
    }

    final userData = await storageRepository.getUser();
    if (userData == null) {
      emit(state.copyWith(status: BegginStatus.notLoged));
      return;
    }

    final user = jsonDecode(userData);

    if (user['cedulaProfesional'] != null) {
      final specialist = SpecialistModel.fromJson(user);

      await multiLogin(specialist.email!, specialist.password!);

      refreshToken(specialist.id!);
    } else {
      final patientModel = PatientModel.fromJson(user, true);

      await multiLogin(patientModel.email!, patientModel.password!);

      refreshToken(patientModel.id!);
    }
  }

  Future<void> setRegisterSet(
    String registerStatus,
  ) async {
    if (state.isPatient!) {
      final patientModel =
          state.patientModel!.copyWith(registerStatus: registerStatus);
      emit(state.copyWith(patientModel: patientModel));
    }
  }

  Future<String> registerPatient(
      PatientModel patientModel, bool remember) async {
    emit(state.copyWith(status: BegginStatus.loading));

    final response = await userRepoitory.createPatient(patientModel);

    if (response == 0) {
      emit(state.copyWith(status: BegginStatus.error));
      return 'error';
    }

    if (response == -1) {
      emit(state.copyWith(status: BegginStatus.error));
      return 'El correo ya está registrado';
    }

    if (response == -2) {
      return 'El teléfono ya está registrado';
    }

    if (response == -3) {
      return 'Error al registrar paciente, el correo o teléfono ya están registrados';
    }

    if (remember) {
      storageRepository.savePatient(patientModel);
    }

    emit(state.copyWith(
      isPatient: true,
    ));
    return 'success';
  }

  Future<String> registerSpecialist(
      SpecialistModel specialistModel, bool remember) async {
    emit(state.copyWith(status: BegginStatus.loading));

    final response = await userRepoitory.createSpecialist(specialistModel);

    if (response == 0) {
      emit(state.copyWith(status: BegginStatus.error));
      return 'error';
    }

    if (response == -1) {
      emit(state.copyWith(status: BegginStatus.error));
      return 'El correo ya está registrado';
    }

    if (response == -2) {
      return 'El teléfono ya está registrado';
    }

    if (response == -3) {
      return 'Error al registrar especialista, el correo o teléfono ya están registrados';
    }

    if (remember) {
      storageRepository.saveSpecialist(specialistModel);
    }

    emit(state.copyWith(
      status: BegginStatus.success,
      isPatient: false,
    ));
    return 'success';
  }

  void logout() async {
    storageRepository.clean();

    emit(const BegginState(
      status: BegginStatus.notLoged,
    ));
  }

  Future<void> setRegisterFlow(int idPatient, String flow) async {
    await storageRepository.saveRegisterPatientFlow(flow);
    await userRepoitory.setRegisterSet(idPatient, flow);
    emit(state.copyWith(registerPatientFlow: flow));
  }

  Future<void> changePrivacy(int patientId, bool notiActivated,
      bool dairyActivated, bool progressActivated) async {
    await userRepoitory.changePrivacy(
      patientId,
      notiActivated,
      dairyActivated,
      progressActivated,
    );

    PatientModel patient = state.patientModel!.copyWith(
      settings: PattientSettings(
        notifications: notiActivated,
        diaryActivated: dairyActivated,
        testActivated: progressActivated,
        id: state.patientModel!.settings!.id,
      ),
    );

    await storageRepository.savePatient(patient);

    emit(state.copyWith(patientModel: patient));
  }

  Future<void> deletePatient(int patientId) async {
    await userRepoitory.deletePatient(patientId);
    storageRepository.clean();
    emit(const BegginState());
  }

  Future<bool> syncByCode(int id, String code) async {
    final response = await userRepoitory.syncByCode(id, code);

    if (response) {
      emit(state.copyWith(
        status: BegginStatus.success,
      ));

      return true;
    } else {
      emit(state.copyWith(status: BegginStatus.errorSingingWithSpecialist));
      return false;
    }
  }

  Future<bool> syncByDirectCode(int id, String code) async {
    final response = await userRepoitory.syncByDirectCode(id, code);

    if (response) {
      final newPatient = await userRepoitory.getPatient(id);

      await storageRepository.savePatient(newPatient);

      emit(state.copyWith(
        status: BegginStatus.success,
        patientModel: newPatient,
      ));

      return true;
    } else {
      emit(state.copyWith(status: BegginStatus.errorSingingWithSpecialist));
      return false;
    }
  }

  Future<bool> refreshToken(int id) async {
    final response = await userRepoitory.refreshToken(id, state.token);

    if (response != null) {
      if (state.isPatient == true && response is PatientModel) {
        final newPatient = state.patientModel!.copyWith(
          token: state.token,
        );
        await storageRepository.savePatient(newPatient);
        emit(state.copyWith(
          status: BegginStatus.success,
          patientModel: newPatient,
        ));
      } else {
        if (response is SpecialistModel) {
          final newSpecialist = state.specialistModel!.copyWith(
            token: state.token,
            tokenForRelate: response.tokenForRelate,
          );
          await storageRepository.saveSpecialist(newSpecialist);

          emit(state.copyWith(
            status: BegginStatus.success,
            specialistModel: newSpecialist,
          ));
        }
      }

      return true;
    } else {
      emit(state.copyWith(status: BegginStatus.errorSingingWithSpecialist));
      return false;
    }
  }

  void setToken(String token) {
    emit(state.copyWith(token: token));
  }

  void changeStatus(
    BegginStatus status,
  ) {
    emit(state.copyWith(status: status));
  }
}



//register
//firstTestCompleted
//registerSuccess