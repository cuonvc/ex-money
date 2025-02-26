import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/note_controller.dart';
import 'package:repository/src/repository/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {

  final noteController = NoteController();
  final userRepository = UserRepositoryImpl();

  @override
  Future getList() async {
    try {
      var resp = await noteController.getNoteList();
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await noteController.getNoteList();
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get Note list error - $e");
      return HttpResponse.toError(sessionExpired, 403);
    }
  }

  @override
  Future saveNote(num? id, NoteModel data) async {
    try {
      var resp = await noteController.saveNote(id, data);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await noteController.saveNote(id, data);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Save note error - $e");
      return HttpResponse.toError(sessionExpired, 403);
    }
  }

  @override
  Future deleteNote(num id) async {
    try {
      var resp = await noteController.deleteNote(id);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await noteController.deleteNote(id);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Delete note error - $e");
      return HttpResponse.toError(sessionExpired, 403);
    }
  }


}