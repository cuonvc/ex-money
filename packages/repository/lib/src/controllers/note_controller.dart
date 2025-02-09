import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';
import 'package:repository/src/utils/utils.dart';

class NoteController {

  Future<dynamic> getNoteList() async {

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.get(
        Uri.parse('$domain/api/note?locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }

  Future<dynamic> saveNote(num? id, NoteModel data) async {

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    if (id == null) { //init
      return http.post(
          Uri.parse('$domain/api/note?locale=vi'),
          headers: {
            // 'Accept-Language': 'vi', //required
            'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(NoteModel.toMap(data))
      );
    } else { //update
      return http.put(
          Uri.parse('$domain/api/note/$id?locale=vi'),
          headers: {
            // 'Accept-Language': 'vi', //required
            'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(NoteModel.toMap(data))
      );
    }
  }

  Future<dynamic> deleteNote(num id) async {

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.delete(
        Uri.parse('$domain/api/note/$id?locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
        }
    );
  }
}