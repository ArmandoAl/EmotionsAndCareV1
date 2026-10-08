import '../../../../helpers/paths.dart';

class DailyCubit extends Cubit<DailyState> {
  final INoteRepository repository;

  DailyCubit({required this.repository}) : super(const DailyState());

  //addNote
  Future<NoteWithAchivement> addNote(NoteModel note, int userId) async {
    emit(state.copyWith(result: DailyResult.loading));
    try {
      final NoteWithAchivement result = await repository.addNote(
        note,
        userId,
        state.notes.isEmpty,
      );

      note = note.copyWith(id: result.id);

      emit(state.copyWith(
          notes: [note, ...state.notes], result: DailyResult.success));

      return result;
    } catch (e) {
      emit(state.copyWith(result: DailyResult.error));
      throw Exception('Failed to add note');
    }
  }

  Future<void> remove(NoteModel note) async {
    try {
      await repository.deleteNote(note.id);

      final notes =
          state.notes.where((element) => element.id != note.id).toList();

      emit(state.copyWith(notes: notes));
    } catch (e) {
      emit(state.copyWith(result: DailyResult.error));
    }
  }

  //getNotes
  Future<void> getNotes(int userId) async {
    emit(state.copyWith(result: DailyResult.loading));
    try {
      final notes = await repository.getNotes(userId);
      emit(state.copyWith(notes: notes, result: DailyResult.success));
    } catch (e) {
      emit(state.copyWith(result: DailyResult.error));
    }
  }

  void changeVisibility(bool visible) {
    emit(state.copyWith(visible: visible));
  }

  void clean() {
    emit(const DailyState());
  }
}
