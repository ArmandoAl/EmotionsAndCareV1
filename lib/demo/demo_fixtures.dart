import '../helpers/paths.dart';
import 'demo_config.dart';

/// Constructores de datos ficticios para el modo demo.
///
/// Nada de lo que hay aquí sale de la API real ni de Firebase: son solo
/// objetos Dart en memoria con forma idéntica a la que produce el backend,
/// pensados para que la UI de producción funcione sin cambios.
TermAndConditions buildDemoTerms() {
  return TermAndConditions(
    id: 1,
    terms: 'Términos de uso de la demostración pública de Emotions&Care. '
        'Esta demo usa datos ficticios y no envía información a ningún servidor.',
  );
}

FlowerModel _buildDemoFlower(int id, String name) {
  return FlowerModel(
    id: id,
    name: name,
    urls: List.generate(
      7,
      (stage) => FlowerImageModel(id: stage, url: ''),
    ),
  );
}

List<UserFlower> buildDemoFlowers() {
  return [
    UserFlower(
      userFlowerId: 1,
      flower: _buildDemoFlower(1, 'Girasol de la calma'),
      state: 3,
      position: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    UserFlower(
      userFlowerId: 2,
      flower: _buildDemoFlower(2, 'Lavanda de la constancia'),
      state: 1,
      position: null,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}

List<UserSticker> buildDemoStickers() {
  return [
    UserSticker(
      userStickerId: 1,
      sticker: StickerModel(id: 1, url: ''),
      position: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    UserSticker(
      userStickerId: 2,
      sticker: StickerModel(id: 2, url: ''),
      position: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}

/// Los ids de logro replican el catálogo fijo del backend real
/// (1=primera carta, 2=primera respuesta, 3=primera nota, 4=primera cita,
/// 5=primer cuestionario) solo para que el copy tenga sentido; en la demo
/// nunca se llama al backend para obtenerlos.
List<UserAchievement> buildDemoAchievements() {
  Achievement achievement(int id, String name, String description) {
    return Achievement(
      achievementId: id,
      name: name,
      description: description,
      category: 0,
      imageUrl: '',
      dateCreated: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  return [
    UserAchievement(
      userAchievementId: 1,
      achievementId: 1,
      achievement: achievement(1, 'Primer mensaje a la comunidad',
          'Compartiste tu primer mensaje anónimo en la comunidad.'),
      progress: 1,
      dateEarned: DateTime.now().subtract(const Duration(days: 6)),
    ),
    UserAchievement(
      userAchievementId: 2,
      achievementId: 2,
      achievement: achievement(2, 'Primera respuesta con empatía',
          'Respondiste a alguien de la comunidad por primera vez.'),
      progress: 0,
      dateEarned: null,
    ),
    UserAchievement(
      userAchievementId: 3,
      achievementId: 3,
      achievement: achievement(3, 'Primera nota del diario',
          'Escribiste tu primera entrada en el diario emocional.'),
      progress: 1,
      dateEarned: DateTime.now().subtract(const Duration(days: 9)),
    ),
    UserAchievement(
      userAchievementId: 4,
      achievementId: 4,
      achievement: achievement(4, 'Primera cita agendada',
          'Agendaste tu primera cita en la agenda.'),
      progress: 1,
      dateEarned: DateTime.now().subtract(const Duration(days: 2)),
    ),
    UserAchievement(
      userAchievementId: 5,
      achievementId: 5,
      achievement: achievement(5, 'Primer cuestionario completado',
          'Completaste tu primer cuestionario de bienestar.'),
      progress: 0,
      dateEarned: null,
    ),
  ];
}

PatientModel buildDemoPatient() {
  return PatientModel(
    id: 900001,
    name: kDemoPatientName,
    email: 'demo@emotionsandcare.app',
    password: '',
    phone: '0000000000',
    age: 21,
    bornDate: DateTime(2004, 3, 15),
    sex: 'F',
    token: '',
    tokenForRelate: '000000',
    termsClass: buildDemoTerms(),
    settings: PattientSettings(
      id: 1,
      notifications: true,
      diaryActivated: true,
      testActivated: true,
    ),
    registerStatus: 'registerSuccess',
    userInterface: UserInterface(
      userInterfaceId: 1,
      userFlowers: buildDemoFlowers(),
      userStickers: buildDemoStickers(),
      backgroundUrl: 1,
      themeId: 0,
    ),
    achivementCollection: AchivementCollection(
      achievementCollectionId: 1,
      userAchievements: buildDemoAchievements(),
    ),
  );
}

List<NotificationModel> buildDemoNotifications() {
  return [
    NotificationModel(
      id: 1,
      title: 'Recomendación',
      type: NotificationType.notificacionRecomendacion,
      description:
          'Prueba dedicar 5 minutos a respirar profundo antes de tu próxima clase.',
      dateEmition: DateTime.now(),
    ),
    NotificationModel(
      id: 2,
      title: 'Diario',
      type: NotificationType.notificacionNota,
      description:
          'No has escrito en tu diario hoy, ¿cómo te sientes en este momento?',
      dateEmition: DateTime.now(),
    ),
  ];
}

List<NoteModel> buildDemoNotes() {
  return [
    NoteModel(
      id: 1,
      title: 'Un buen inicio de semana',
      content:
          'Hoy me sentí con energía para empezar mis pendientes de la universidad.',
      emotion: EmotionModel(id: 1, name: 'Alegría', icon: '😄'),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      visible: true,
    ),
  ];
}

List<TestModel> buildDemoTests() {
  ResponseModel r(int id, String text, int value) =>
      ResponseModel(id: id, response: text, value: value);

  return [
    TestModel(
      id: 1,
      name: 'Chequeo de energía semanal',
      description: 'Un vistazo rápido y ligero a cómo te has sentido de energía esta semana.',
      objetive: 'Reflexionar brevemente sobre tu semana (solo con fines demostrativos).',
      instructions: 'Elige la opción que más se acerque a cómo te sientes.',
      questions: [
        QuestionModel(
          id: 1001,
          question: '¿Cómo describirías tu energía esta semana?',
          type: QuestionType.multiple,
          answers: [
            r(1, 'Muy baja', 0),
            r(2, 'Baja', 1),
            r(3, 'Buena', 2),
            r(4, 'Muy buena', 3),
          ],
        ),
        QuestionModel(
          id: 1002,
          question: '¿Has podido descansar lo suficiente?',
          type: QuestionType.multiple,
          answers: [
            r(5, 'Casi nunca', 0),
            r(6, 'A veces', 1),
            r(7, 'Casi siempre', 2),
            r(8, 'Siempre', 3),
          ],
        ),
        QuestionModel(
          id: 1003,
          question: '¿Qué tan motivado te sientes hoy?',
          type: QuestionType.multiple,
          answers: [
            r(9, 'Nada', 0),
            r(10, 'Un poco', 1),
            r(11, 'Bastante', 2),
            r(12, 'Mucho', 3),
          ],
        ),
      ],
    ),
    TestModel(
      id: 2,
      name: 'Termómetro del ánimo',
      description: 'Un ejercicio corto para ponerle palabras a tu estado de ánimo de hoy.',
      objetive: 'Practicar la autobservación emocional (solo con fines demostrativos).',
      instructions: 'No hay respuestas correctas o incorrectas, solo responde con honestidad.',
      questions: [
        QuestionModel(
          id: 2001,
          question: '¿Cómo calificarías tu ánimo general hoy?',
          type: QuestionType.multiple,
          answers: [
            r(13, 'Muy bajo', 0),
            r(14, 'Bajo', 1),
            r(15, 'Neutral', 2),
            r(16, 'Alto', 3),
          ],
        ),
        QuestionModel(
          id: 2002,
          question: '¿Sentiste estrés en algún momento del día?',
          type: QuestionType.boolean,
          answers: [
            r(17, 'Sí', 1),
            r(18, 'No', 0),
          ],
        ),
        QuestionModel(
          id: 2003,
          question: '¿Te gustaría escribir sobre algo en tu diario hoy?',
          type: QuestionType.boolean,
          answers: [
            r(19, 'Sí', 1),
            r(20, 'No', 0),
          ],
        ),
      ],
    ),
  ];
}

List<CartModel> buildDemoCommunityInbox() {
  return [
    CartModel(
      id: 501,
      idEmisor: 700501,
      letraEmisor: 'A',
      contenido:
          'Esta semana los exámenes me tienen agobiada, pero escribir esto ya me ayuda un poco.',
      estado: EstadoCarta.enviada,
      respuestas: const [],
      fechaCreacion: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CartModel(
      id: 502,
      idEmisor: 700502,
      letraEmisor: 'M',
      contenido:
          'Hoy logré organizar mis pendientes por primera vez en semanas. Pequeños logros cuentan.',
      estado: EstadoCarta.enviada,
      respuestas: const [],
      fechaCreacion: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];
}

List<CartModel> buildDemoMyCarts() {
  return [
    CartModel(
      id: 401,
      idEmisor: 900001,
      letraEmisor: 'E',
      contenido: 'Gracias a quien lea esto: hoy decidí darme un respiro y está bien hacerlo.',
      estado: EstadoCarta.enviada,
      respuestas: const [],
      fechaCreacion: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];
}

List<SpecialistModel> buildDemoSpecialists() {
  SpecialistModel build(int id, String name, String focus, String institution) {
    return SpecialistModel(
      id: id,
      name: name,
      email: 'demo.$id@emotionsandcare.app',
      phone: '0000000000',
      age: 35,
      bornDate: DateTime(1989, 1, 1),
      sex: 'F',
      token: '',
      termsClass: buildDemoTerms(),
      professionalLicense: 'DEMO-$id',
      focus: focus,
      institution: institution,
      ubication: 'Campus demo',
      presentation:
          'Perfil ficticio incluido solo para mostrar el flujo de agenda de la demo.',
      patients: const [],
    );
  }

  return [
    build(800001, 'Dra. Renata Campos', 'Ansiedad', 'Centro de bienestar universitario'),
    build(800002, 'Dr. Iván Solís', 'Manejo del estrés', 'Centro de bienestar universitario'),
    build(800003, 'Dra. Paola Nieto', 'Hábitos de sueño', 'Centro de bienestar universitario'),
  ];
}

List<DateModel> buildDemoDates() {
  return [
    DateModel(
      id: 301,
      date: DateTime.now().add(const Duration(days: 3)),
      hour: '10:00',
      place: 'Consultorio virtual demo',
      description: 'Primera sesión de seguimiento (ficticia).',
      confirmByPatient: true,
      confirmByEspetialist: true,
      status: DateStatus.confirmed,
    ),
  ];
}
