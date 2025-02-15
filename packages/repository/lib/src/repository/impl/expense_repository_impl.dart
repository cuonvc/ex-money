import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/expense_controller.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {

  final expenseController = ExpenseController();
  final userRepository = UserRepositoryImpl();

  @override
  Future<dynamic> getExpenseList(num? walletId, String? keyword, num? categoryId, num? createdById, String? startDate, String? endDate) async {
    try {
      var resp = await expenseController.getExpenseList(walletId, keyword, categoryId, createdById, startDate, endDate);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await expenseController.getExpenseList(walletId, keyword, categoryId, createdById, startDate, endDate);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get expense error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future getExpenseEditResource(num? walletId) async {
    try {
      var resp = await expenseController.getExpenseResourceForEdit(walletId);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await expenseController.getExpenseResourceForEdit(walletId);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get expense edit resource error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future addExpense(ExpenseCreateRequest request) async {
    try {
      var resp = await expenseController.addExpense(request);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await expenseController.addExpense(request);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Add expense resource error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future updateExpense(num id, ExpenseUpdateRequest request) async {
    try {
      var resp = await expenseController.updateExpense(id, request);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await expenseController.updateExpense(id, request);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Update expense resource error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future deleteExpense(num id) async {
    try {
      var resp = await expenseController.deleteExpense(id);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await expenseController.deleteExpense(id);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Delete expense resource error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future getExpenseFilterResource(num? walletId) async {
    try {
      var resp = await expenseController.getExpenseResourceForFilter(walletId);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await expenseController.getExpenseResourceForFilter(walletId);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get expense filter resource error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future getConfirmExpenseFromSpeech(String text) async {
    try {
      var resp = await expenseController.getConfirmExpenseFromSpeech(text);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await expenseController.getConfirmExpenseFromSpeech(text);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get confirm expense from Speech error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }



}