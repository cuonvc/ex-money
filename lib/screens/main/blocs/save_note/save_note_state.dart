part of 'save_note_bloc.dart';

sealed class SaveNoteState extends Equatable {
  const SaveNoteState();

  @override
  List<Object> get props => [];
}

final class SaveNoteInitial extends SaveNoteState {}
final class SaveNoteLoading extends SaveNoteState {}
final class SaveNoteFailure extends SaveNoteState {
  final String message;

  const SaveNoteFailure({
    required this.message
  });
}

final class SaveNoteSuccess extends SaveNoteState {
  final NoteModel data;

  const SaveNoteSuccess({
    required this.data
  });
}