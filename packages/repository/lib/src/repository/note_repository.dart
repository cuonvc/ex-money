import 'package:repository/repository.dart';

abstract class NoteRepository {
  Future<dynamic> getList();
  Future<dynamic> saveNote(num? id, NoteModel data);
  Future<dynamic> deleteNote(num id);
}