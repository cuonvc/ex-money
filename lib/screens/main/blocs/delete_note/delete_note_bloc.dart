import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'delete_note_event.dart';
part 'delete_note_state.dart';

class DeleteNoteBloc extends Bloc<DeleteNoteEvent, DeleteNoteState> {

  final NoteRepository noteRepository;

  DeleteNoteBloc(this.noteRepository) : super(DeleteNoteInitial()) {
    on<DeleteNoteEv>((event, emit) async {
      emit(DeleteNoteLoading());
      try {
        HttpResponse response = await noteRepository.deleteNote(event.id);
        if (response.code == 0) {
          emit(DeleteNoteSuccess(id: event.id));
        } else {
          emit(DeleteNoteFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Failed to delete note");
        emit(DeleteNoteFailure(statusCode: 1, message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
