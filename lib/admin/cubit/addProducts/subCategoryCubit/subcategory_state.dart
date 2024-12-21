part of 'subcategory_cubit.dart';

@immutable
sealed class SubcategoryState {}

final class SubcategoryInitial extends SubcategoryState {}

final class SubcategoryListLoading extends SubcategoryState {}

final class SubcategoryListSuccess extends SubcategoryState {
  List<Subcategory> subcategories;

  SubcategoryListSuccess(this.subcategories);
}

final class SubcategoryFail extends SubcategoryState {
  String Failerror;

  SubcategoryFail(this.Failerror);
}

final class SubcategoryAddNewSubcategoryInitial extends SubcategoryState {}

final class SubcategoryAddNewSubcategorySuccess extends SubcategoryState {}

final class SubcategoryAddNewSubcategoryFail extends SubcategoryState {
  String error;

  SubcategoryAddNewSubcategoryFail(this.error);
}
