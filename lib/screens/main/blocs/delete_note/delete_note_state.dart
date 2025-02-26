part of 'delete_note_bloc.dart';

sealed class DeleteNoteState extends Equatable {
  const DeleteNoteState();

  @override
  List<Object> get props => [];
}

final class DeleteNoteInitial extends DeleteNoteState {}
final class DeleteNoteLoading extends DeleteNoteState {}
final class DeleteNoteFailure extends DeleteNoteState {
  final int statusCode;
  final String message;

  const DeleteNoteFailure({
    required this.statusCode,
    required this.message
  });
}

final class DeleteNoteSuccess extends DeleteNoteState {
  final num id;

  const DeleteNoteSuccess({
    required this.id
  });
}