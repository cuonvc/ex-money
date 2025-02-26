import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'get_note_list_event.dart';
part 'get_note_list_state.dart';

class GetNoteListBloc extends Bloc<GetNoteListEvent, GetNoteListState> {

  final NoteRepository noteRepository;

  GetNoteListBloc(this.noteRepository) : super(GetNoteListInitial()) {
    on<GetNoteListEvent>((event, emit) async {
      emit(GetNoteListLoading());
      try {
        HttpResponse response = await noteRepository.getList();
        if (response.code == 0) {
          List list = response.data[0];
          List<NoteModel> dataList = list.map((e) => NoteModel.fromMap(e)).toList();
          emit(GetNoteListSuccess(list: dataList));
        } else {
          emit(GetNoteListFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Get Note list failed: $e");
        emit(GetNoteListFailure(statusCode: 1, message: e.toString()));
      }
    });
  }
}
