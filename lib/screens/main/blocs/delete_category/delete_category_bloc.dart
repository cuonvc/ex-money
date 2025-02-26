import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'delete_category_event.dart';
part 'delete_category_state.dart';

class DeleteCategoryBloc extends Bloc<DeleteCategoryEvent, DeleteCategoryState> {

  final CategoryRepository categoryRepository;

  DeleteCategoryBloc(this.categoryRepository) : super(DeleteCategoryInitial()) {
    on<DeleteCategoryEv>((event, emit) async {
      emit(DeleteCategoryLoading());

      try {
        HttpResponse response = await categoryRepository.deleteById(event.id);
        if (response.code == 0) {
          emit(const DeleteCategorySuccess(message: "Đã xóa"));
        } else {
          emit(DeleteCategoryFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Error delete category: ${e.toString()}");
        emit(DeleteCategoryFailure(statusCode: 1, message: e.toString()));
      }
    });
  }
}
