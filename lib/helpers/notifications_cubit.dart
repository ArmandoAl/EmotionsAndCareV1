// ignore_for_file: avoid_print
import 'package:emotions_and_care_v1/helpers/paths.dart';
import 'package:emotions_and_care_v1/modules/patients_request/presentation/logic/patient_request_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseNotificationsCubit extends Cubit<NotificationState> {
  final BegginCubit begginCubit;
  final HomeCubit homeCubit;
  final PatientsRequestCubit patientsRequestCubit;

  FirebaseNotificationsCubit(
      {required this.begginCubit,
      required this.homeCubit,
      required this.patientsRequestCubit})
      : super(const NotificationState());

  // Perezoso a propósito: acceder a `FirebaseMessaging.instance` requiere
  // que exista una app de Firebase inicializada. En modo demo nunca se
  // llama a `initialize()` (ver `service_locator.dart`), pero si esta
  // propiedad fuera un campo con inicialización inmediata, se evaluaría al
  // construir el cubit y fallaría igual sin haber inicializado Firebase.
  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _firebaseMessaging.setAutoInitEnabled(true);

    final String os = getPlattform();
    final NotificationSettings res = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (res.authorizationStatus == AuthorizationStatus.authorized) {
      _firebaseMessaging.onTokenRefresh.listen((token) {
        begginCubit.setToken(token);
        emit(state.copyWith(token: token));
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        mapNotification(message.data);
        emit(state.copyWith(message: message.data));
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      String token = "";
      if (os == 'ios') {
        token = await _firebaseMessaging.getAPNSToken() ?? "";
      } else {
        if (os == 'android') {
          token = await _firebaseMessaging.getToken() ?? "";
        } else {
          token = await _firebaseMessaging.getToken(
                  vapidKey:
                      'BGy55eiZlgAsS4l_k7PWBoZIlCCE8LOZxP8dtg8atKjOYygUErmmgt3P_OWbS2hR2tVG8raf0aDojYzepCZcWi8') ??
              "";

          print('Token: $token');
        }
      }

      begginCubit.setToken(token);
      emit(state.copyWith(token: token));
    } else {
      print('User declined or has not accepted permission');
      emit(state.copyWith(token: ''));
    }
  }

  void mapNotification(
    Map<String, dynamic> data,
  ) {
    final String type = data['module'] ?? '{}';
    switch (type) {
      case 'schedule':
        final String action = data['event'] ?? '';
        switch (action) {
          case 'newRequest':
            // patientsRequestCubit
            //     .getPatientsRequestList(begginCubit.state.specialistModel!.id!);
            break;
          case "newDateBySpecialist":
            // homeCubit
            //     .getDatesForSpecialist(begginCubit.state.specialistModel!.id!);
            break;
          case "dateUpdated":
            //var si es paciente o no
            // homeCubit
            //     .getDatesForSpecialist(begginCubit.state.specialistModel!.id!);
            break;
          default:
            break;
        }
        break;
      case 'patientRequest':
        final String action = data['event'] ?? '';
        switch (action) {
          case 'newRequest':
            patientsRequestCubit
                .getPatientsRequestList(begginCubit.state.specialistModel!.id!);
            break;
          default:
            break;
        }

        break;
      case 'yard':
        final String action = data['event'] ?? '';
        switch (action) {
          case 'canGrow':
            // begginCubit.changeStatus(BegginStatus.growing);
            //add manual code here about create the note
            break;
          default:
            break;
        }

        break;
      case 'sync':
        final String action = data['event'] ?? '';
        switch (action) {
          case 'specialistSync':
            if (begginCubit.state.patientModel != null) {
              begginCubit.reloginPatient(
                begginCubit.state.patientModel!,
              );
            }
            break;
          case 'patientSync':
            if (begginCubit.state.specialistModel != null) {
              // begginCubit.getPatients(
              //   begginCubit.state.specialistModel!,
              // );
            }
            break;
          default:
            break;
        }

        break;
      default:
        break;
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

class NotificationState extends Equatable {
  final Map<String, dynamic> message;
  final String token;
  final bool uploadingToken;
  final bool tokenUploaded;
  final bool uploadError;

  const NotificationState({
    this.message = const {},
    this.token = '',
    this.uploadingToken = false,
    this.tokenUploaded = false,
    this.uploadError = false,
  });

  NotificationState copyWith({
    Map<String, dynamic>? message,
    String? token,
    bool? uploadingToken,
    bool? tokenUploaded,
    bool? uploadError,
  }) {
    return NotificationState(
      message: message ?? this.message,
      token: token ?? this.token,
      uploadingToken: uploadingToken ?? this.uploadingToken,
      tokenUploaded: tokenUploaded ?? this.tokenUploaded,
      uploadError: uploadError ?? this.uploadError,
    );
  }

  @override
  List<Object> get props => [
        message,
        token,
        uploadingToken,
        tokenUploaded,
        uploadError,
      ];
}

String getPlattform() {
  if (kIsWeb) {
    return "web";
  } else if (Platform.isAndroid) {
    return "android";
  } else if (Platform.isIOS) {
    return "ios";
  } else {
    return "desconocido";
  }
}

// web       1:337730650555:web:f9629f09774e07edbcc49e
// android   1:337730650555:android:0223342204b1cf2ebcc49e
// ios       1:337730650555:ios:94bbde6931b348cebcc49e
