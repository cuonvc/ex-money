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
        List data = await categoryRepository.getCategoryList(event.walletId);
        emit(GetCategorySuccess(data));
      } catch (e) {
        log("Get category failed - $e");
        emit(GetCategoryFailure());
      }
    });
  }
}
