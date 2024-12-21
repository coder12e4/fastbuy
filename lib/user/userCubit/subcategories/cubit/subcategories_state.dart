part of 'subcategories_cubit.dart';

@immutable
sealed class SubcategoriesState {}

final class SubcategoriesInitial extends SubcategoriesState {}

final class SubcategoriesLoading extends SubcategoriesState {}

final class SubcategoriesSuccess extends SubcategoriesState {
  List<Subcategory> listSubcategoris;
  SubcategoriesSuccess(this.listSubcategoris);
}

final class SubcategoriesFailed extends SubcategoriesState {}
