part of 'save_note_bloc.dart';

sealed class SaveNoteEvent extends Equatable {
  const SaveNoteEvent();

  @override
  List<Object> get props => [];
}

class SaveNoteEv extends SaveNoteEvent {
  final num? id;
  final NoteModel data;

  const SaveNoteEv({
    required this.id,
    required this.data
  });
}