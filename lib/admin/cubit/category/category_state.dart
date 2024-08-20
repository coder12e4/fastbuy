part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  List<Category> categories;

  CategorySuccess(this.categories);
}

final class CategoryFail extends CategoryState {}

final class CategoryAddLoading extends CategoryState {}

final class CategoryAddSuccess extends CategoryState {}

final class CategoryAddFail extends CategoryState {}
