part of 'home_admin_cubit.dart';

@immutable
sealed class HomeAdminState {}

final class HomeAdminInitial extends HomeAdminState {}

final class HomeAdminLoading extends HomeAdminState {}

final class HomeAdminSuccess extends HomeAdminState {
  List<Category> categories;
  HomeAdminSuccess(this.categories);
}

final class LoadSubcategorisLoding extends HomeAdminState {}

final class LoadSubcategorisSuccess extends HomeAdminState {
  List<Subcategory> subcategory;
  LoadSubcategorisSuccess(this.subcategory);
}

final class LoadSubcategorisFail extends HomeAdminState {
  String error;
  LoadSubcategorisFail(this.error);
}

final class LoadProductsLoading extends HomeAdminState {}

final class LoadProductsSuccess extends HomeAdminState {
  List<Product> productList;
  LoadProductsSuccess(this.productList);
}

final class LoadProductsFailed extends HomeAdminState {
  String error;
  LoadProductsFailed(this.error);
}

final class HomeAdminFailed extends HomeAdminState {}
