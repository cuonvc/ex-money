part of 'get_category_bloc.dart';

sealed class GetCategoryEvent extends Equatable {
  const GetCategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoryEv extends GetCategoryEvent {
  ExpenseCategoryResponse? category;
  final num? walletId;
  final bool isReload;

  GetCategoryEv({
    required this.walletId,
    required this.isReload
  });

  @override
  List<Object?> get props => [category];
}
