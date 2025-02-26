import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'save_category_event.dart';
part 'save_category_state.dart';

class SaveCategoryBloc extends Bloc<SaveCategoryEvent, SaveCategoryState> {

  final CategoryRepository categoryRepository;

  SaveCategoryBloc(this.categoryRepository) : super(SaveCategoryInitial()) {
    on<SaveCategoryEv>((event, emit) async {
      emit(SaveCategoryLoading());
      try {
        HttpResponse response = await categoryRepository.saveCategory(event.id, event.request);
        if (response.code == 0) {
          ExpenseCategoryResponse category = ExpenseCategoryResponse.fromMap(response.data[0]);
          emit(SaveCategorySuccess(message: "Đã cập nhật danh mục", response: category));
        } else {
          emit(SaveCategoryFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Failed to save category");
        emit(SaveCategoryFailure(statusCode: 1, message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
