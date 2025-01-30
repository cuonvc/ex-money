import 'package:repository/repository.dart';

class ExpenseSchedulerResponse {
  late num id;
  late num refId;
  late String refTable;
  late String taskName;
  late String timeInterval;
  late int timeValue;
  late String status;
  late String createdAt;
  late int createdBy;
  late String updatedAt;
  late int updatedBy;
  late ExpenseResponse data;

  ExpenseSchedulerResponse({
    required this.id,
    required this.refId,
    required this.refTable,
    required this.taskName,
    required this.timeInterval,
    required this.timeValue,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.data,
  });

  Map<String, dynamic> toMap(ExpenseSchedulerResponse obj) {
    Map<String, dynamic> data = ExpenseResponse.toMap(obj.data);
    return {
      'id': obj.id,
      'refId': obj.refId,
      'refTable': obj.refTable,
      'taskName': obj.taskName,
      'timeInterval': obj.timeInterval,
      'timeValue': obj.timeValue,
      'status': obj.status,
      'createdAt': obj.createdAt,
      'createdBy': obj.createdBy,
      'updatedAt': obj.updatedAt,
      'updatedBy': obj.updatedBy,
      'data': data,
    };
  }

  static ExpenseSchedulerResponse fromMap(Map<String, dynamic> map) {
    ExpenseResponse data = ExpenseResponse.fromMap(map['data']);
    return ExpenseSchedulerResponse(
      id: map['id'],
      refId: map['refId'],
      refTable: map['refTable'],
      taskName: map['taskName'],
      timeInterval: map['timeInterval'],
      timeValue: map['timeValue'],
      status: map['status'],
      createdAt: map['createdAt'],
      createdBy: map['createdBy'],
      updatedAt: map['updatedAt'],
      updatedBy: map['updatedBy'],
      data: data,
    );
  }
}