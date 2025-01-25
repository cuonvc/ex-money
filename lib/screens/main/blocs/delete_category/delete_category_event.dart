part of 'delete_category_bloc.dart';

sealed class DeleteCategoryEvent extends Equatable {
  const DeleteCategoryEvent();

  @override
  List<Object> get props => [];
}

class DeleteCategoryEv extends DeleteCategoryEvent {
  final num id;

  const DeleteCategoryEv({
    required this.id
  });
}
