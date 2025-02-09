import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ex_money/screens/main/blocs/update_expense/update_expense_bloc.dart';
import 'package:repository/repository.dart';

part 'save_note_event.dart';
part 'save_note_state.dart';

class SaveNoteBloc extends Bloc<SaveNoteEvent, SaveNoteState> {

  final NoteRepository noteRepository;

  SaveNoteBloc(this.noteRepository) : super(SaveNoteInitial()) {
    on<SaveNoteEv>((event, emit) async {
      emit(SaveNoteLoading());
      try {
        HttpResponse response = await noteRepository.saveNote(event.id, event.data);
        if (response.code == 0) {
          NoteModel data = NoteModel.fromMap(response.data[0]);
          emit(SaveNoteSuccess(data: data));
        } else {
          emit(SaveNoteFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to save note");
        emit(SaveNoteFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
