import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'get_category_event.dart';
part 'get_category_state.dart';

class GetCategoryBloc extends Bloc<GetCategoryEvent, GetCategoryState> {

  final CategoryRepository categoryRepository;

  GetCategoryBloc(this.categoryRepository) : super(GetCategoryInitial()) {
    on<GetCategoryEv>((event, emit) async {
      emit(GetCategoryLoading());
      try {
        HttpResponse response = await categoryRepository.getCategoryList(event.walletId);
        if (response.code == 0) {
          List<ExpenseCategoryResponse> data = ExpenseCategoryResponse.fromList(response.data[0]);
          emit(GetCategorySuccess(data));
        } else {
          emit(GetCategoryFailure(response.message));
        }
      } catch (e) {
        log("Get category failed - $e");
        emit(GetCategoryFailure(e.toString()));
      }
    });
  }
}
