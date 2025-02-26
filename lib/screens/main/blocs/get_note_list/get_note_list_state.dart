part of 'get_note_list_bloc.dart';

sealed class GetNoteListState extends Equatable {
  const GetNoteListState();

  @override
  List<Object> get props => [];
}

final class GetNoteListInitial extends GetNoteListState {}
final class GetNoteListLoading extends GetNoteListState {}
final class GetNoteListFailure extends GetNoteListState {
  final int statusCode;
  final String message;

  const GetNoteListFailure({
    required this.statusCode,
    required this.message
  });
}

final class GetNoteListSuccess extends GetNoteListState {
  final List<NoteModel> list;

  const GetNoteListSuccess({
    required this.list
  });
}