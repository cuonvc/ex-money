part of 'get_category_bloc.dart';

sealed class GetCategoryEvent extends Equatable {
  const GetCategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoryEv extends GetCategoryEvent {
  ExpenseCategoryResponse? category;
  String? walletId;

  GetCategoryEv(this.walletId);

  @override
  List<Object?> get props => [category];
}
