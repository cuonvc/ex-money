part of 'delete_category_bloc.dart';

sealed class DeleteCategoryState extends Equatable {
  const DeleteCategoryState();

  @override
  List<Object> get props => [];
}

final class DeleteCategoryInitial extends DeleteCategoryState {}
final class DeleteCategoryLoading extends DeleteCategoryState {}
final class DeleteCategoryFailure extends DeleteCategoryState {
  final String message;

  const DeleteCategoryFailure({
    required this.message
  });
}

final class DeleteCategorySuccess extends DeleteCategoryState {
  final String message;

  const DeleteCategorySuccess({
    required this.message
  });
}