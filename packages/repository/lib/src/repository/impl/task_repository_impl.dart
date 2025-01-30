import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/task_controller.dart';
import 'package:repository/src/repository/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {

  final taskController = TaskController();
  final userRepository = UserRepositoryImpl();

  @override
  Future createExpenseScheduler(ExpenseSchedulerRequest request) async {
    try {
      var resp = await taskController.expenseSchedulerCreate(request);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await taskController.expenseSchedulerCreate(request);
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Create expense scheduler error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }


}