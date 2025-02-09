part of 'get_note_list_bloc.dart';

sealed class GetNoteListEvent extends Equatable {
  const GetNoteListEvent();

  @override
  List<Object> get props => [];
}

class GetNoteListEv extends GetNoteListEvent {
  const GetNoteListEv();
}