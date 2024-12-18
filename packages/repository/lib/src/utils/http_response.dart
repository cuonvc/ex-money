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
        data: response['data'] != null ? response['data'] : []
    );
  }

  static HttpResponse toError(String? message) {
    return HttpResponse(
        code: 1,
        status: '',
        statusCode: 1,
        message: message != null ? message : '',
        data: []
    );
  }
}