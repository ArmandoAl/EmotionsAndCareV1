import '../helpers/paths.dart';
import 'demo_fixtures.dart';

/// Estado en memoria compartido por todos los repositorios demo.
///
/// Es deliberadamente simple (listas mutables estáticas) porque solo vive
/// mientras dura la pestaña del navegador: al recargar la página (ver
/// `demo_reset.dart`) el proceso completo arranca de cero y estos valores
/// se vuelven a inicializar desde `demo_fixtures.dart`.
class DemoDataStore {
  DemoDataStore._();

  static PatientModel patient = buildDemoPatient();

  static final List<NotificationModel> notifications = buildDemoNotifications();

  static final List<NoteModel> notes = buildDemoNotes();
  static int _nextNoteId = 100;

  static final List<TestModel> tests = buildDemoTests();
  static final List<CompletedTestModel> completedTests = [];
  static final List<HistoryTestModel> historyTests = [];
  static int _nextTestInfoId = 1;
  static int _nextTestHistoryId = 1;

  /// Cartas de otras personas de la comunidad (ficticias) pendientes de respuesta.
  static final List<CartModel> communityInbox = buildDemoCommunityInbox();

  /// Cartas enviadas por el propio usuario demo.
  static final List<CartModel> myCarts = buildDemoMyCarts();
  static int _nextCartId = 600;

  static final List<SpecialistModel> specialists = buildDemoSpecialists();
  static final List<DateModel> dates = buildDemoDates();
  static int _nextDateId = 400;

  static int get nextNoteId => _nextNoteId++;
  static int get nextTestInfoId => _nextTestInfoId++;
  static int get nextTestHistoryId => _nextTestHistoryId++;
  static int get nextCartId => _nextCartId++;
  static int get nextDateId => _nextDateId++;
}
