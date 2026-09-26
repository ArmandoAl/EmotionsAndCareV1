import '../../helpers/paths.dart';
import '../demo_data_store.dart';

/// Reemplazo en memoria de [INoteRepository] (módulo Diario) para el modo demo.
class DemoNoteRepository implements INoteRepository {
  @override
  Future<NoteWithAchivement> addNote(
      NoteModel note, int patientId, bool isFirstTime) async {
    final int id = DemoDataStore.nextNoteId;
    DemoDataStore.notes.insert(0, note.copyWith(id: id));

    return NoteWithAchivement(
      id: id,
      achivementId: isFirstTime ? 3 : null,
    );
  }

  @override
  Future<bool> deleteNote(int idNote) async {
    DemoDataStore.notes.removeWhere((element) => element.id == idNote);
    return true;
  }

  @override
  Future<List<NoteModel>> getNotes(int patientId) async {
    return List<NoteModel>.from(DemoDataStore.notes);
  }
}
