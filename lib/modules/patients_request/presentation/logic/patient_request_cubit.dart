import 'package:emotions_and_care_v1/helpers/paths.dart';
import 'package:equatable/equatable.dart';

class PatientsRequestCubit extends Cubit<PatientsRequestsState> {
  final IUserRepository userRepository;
  final SpecialistRepository specialistRepository;

  PatientsRequestCubit({
    required this.userRepository,
    required this.specialistRepository,
  }) : super(const PatientsRequestsState());

  Future<void> getPatientsRequestList(int idUser) async {
    emit(const PatientsRequestsState(status: PatientsRequestsStatus.loading));
    final List<PatientRequest> list =
        await specialistRepository.getPatientRequest(idUser);

    emit(PatientsRequestsState(
      status: PatientsRequestsStatus.loaded,
      patientsRequest: list,
    ));
  }

  Future<bool> acceptPatientRequest(
      int idSpecialist, int idPatient, int idPatientRequest) async {
    bool result = await specialistRepository.acceptPatientRequest(
        idSpecialist, idPatient, idPatientRequest);

    if (result) {
      List<PatientRequest> list = state.patientsRequest
          .where((element) => element.id != idPatientRequest)
          .toList();

      emit(state.copyWith(patientsRequest: list));
    }

    return result;
  }

  Future<bool> rejectPatientRequest(
      int idSpecialist, int idPatient, int idPatientRequest) async {
    bool result = await specialistRepository.rejectPatientRequest(
        idSpecialist, idPatient, idPatientRequest);

    if (result) {
      List<PatientRequest> list = state.patientsRequest
          .where((element) => element.patient.id != idPatient)
          .toList();

      emit(state.copyWith(patientsRequest: list));
    }

    return result;
  }
}

enum PatientsRequestsStatus { initial, loading, loaded, error }

class PatientsRequestsState extends Equatable {
  final PatientsRequestsStatus status;
  final List<PatientRequest> patientsRequest;

  const PatientsRequestsState({
    this.status = PatientsRequestsStatus.initial,
    this.patientsRequest = const [],
  });

  //copyWith method
  PatientsRequestsState copyWith({
    PatientsRequestsStatus? status,
    List<PatientRequest>? patientsRequest,
  }) {
    return PatientsRequestsState(
      status: status ?? this.status,
      patientsRequest: patientsRequest ?? this.patientsRequest,
    );
  }

  @override
  List<Object> get props => [status, patientsRequest];
}
