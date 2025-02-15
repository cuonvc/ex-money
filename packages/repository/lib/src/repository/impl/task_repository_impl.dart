import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/task_controller.dart';

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
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Create expense scheduler error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future updateExpenseScheduler(num id, ExpenseSchedulerRequest request) async {
    try {
      var resp = await taskController.expenseSchedulerUpdate(id, request);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await taskController.expenseSchedulerUpdate(id, request);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Update expense scheduler error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }


}