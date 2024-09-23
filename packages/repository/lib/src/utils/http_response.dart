import 'dart:io';

class HttpResponse {
  late int code;
  late String status;
  late int statusCode;
  late String message;
  late List data;

  HttpResponse({
    required this.code,
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data
  });

  static HttpResponse toObject(Map<String, dynamic> response) {
    return HttpResponse(
        code: response['code'],
        status: response['status'],
        statusCode: response['statusCode'],
        message: response['message'],
        data: response['data']
    );
  }
}