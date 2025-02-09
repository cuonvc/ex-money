part of 'delete_note_bloc.dart';

sealed class DeleteNoteEvent extends Equatable {
  const DeleteNoteEvent();

  @override
  List<Object> get props => [];
}

class DeleteNoteEv extends DeleteNoteEvent {
  final num id;

  const DeleteNoteEv({
    required this.id
  });
}
