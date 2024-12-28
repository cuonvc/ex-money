part of 'save_category_bloc.dart';

sealed class SaveCategoryEvent extends Equatable {
  const SaveCategoryEvent();

  @override
  List<Object> get props => [];
}

class SaveCategoryEv extends SaveCategoryEvent {
  final num? id;
  final ExpenseCategoryRequest request;

  const SaveCategoryEv({
    required this.id,
    required this.request
  });
}
