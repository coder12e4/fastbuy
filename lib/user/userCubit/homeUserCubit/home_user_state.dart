part of 'home_user_cubit.dart';

@immutable
sealed class HomeUserState {}

final class HomeUserInitial extends HomeUserState {}

final class HomeUserLoading extends HomeUserState {}

final class HomeUserSucess extends HomeUserState {
  List<Product> listAllProducts;
  List<Category> listCategoris;
  HomeUserSucess(this.listAllProducts, this.listCategoris);
}

final class HomeUserFail extends HomeUserState {}

//selected subcategory
final class subCategoryProductsLoading extends HomeUserState {}

final class subCategoryProductsSucess extends HomeUserState {}

final class subCategoryProductsFail extends HomeUserState {}
//
