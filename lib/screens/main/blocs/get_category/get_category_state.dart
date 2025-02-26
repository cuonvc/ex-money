part of 'get_category_bloc.dart';

sealed class GetCategoryState extends Equatable {
  const GetCategoryState();
  List<Object?> get props => [];
}

final class GetCategoryInitial extends GetCategoryState {}
final class GetCategoryLoading extends GetCategoryState {}
final class GetCategoryFailure extends GetCategoryState {
  final int statusCode;
  final String message;

  const GetCategoryFailure({
    required this.statusCode,
    required this.message
  });
}
final class GetCategorySuccess extends GetCategoryState {
  final List<ExpenseCategoryResponse> data;
  final List<Map<dynamic, dynamic>> walletListInfo;

  const GetCategorySuccess(this.data, this.walletListInfo);
}
