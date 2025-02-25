part of 'get_category_bloc.dart';

sealed class GetCategoryEvent extends Equatable {
  const GetCategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoryEv extends GetCategoryEvent {
  ExpenseCategoryResponse? category;
  final num? walletId;
  final String keyword;
  final bool isReload;
  final bool isCache;

  GetCategoryEv({
    required this.walletId,
    required this.keyword,
    required this.isReload,
    required this.isCache
  });

  @override
  List<Object?> get props => [category];
}
