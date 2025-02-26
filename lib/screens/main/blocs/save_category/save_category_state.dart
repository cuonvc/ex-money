part of 'save_category_bloc.dart';

sealed class SaveCategoryState extends Equatable {
  const SaveCategoryState();

  @override
  List<Object> get props => [];
}

final class SaveCategoryInitial extends SaveCategoryState {}
final class SaveCategoryLoading extends SaveCategoryState {}
final class SaveCategoryFailure extends SaveCategoryState {
  final int statusCode;
  final String message;

  const SaveCategoryFailure({
    required this.statusCode,
    required this.message
  });
}
final class SaveCategorySuccess extends SaveCategoryState {
  final String message;
  final ExpenseCategoryResponse response;

  const SaveCategorySuccess({
    required this.message,
    required this.response
  });
}
