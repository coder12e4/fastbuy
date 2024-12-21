part of 'home_user_cubit.dart';

@immutable
sealed class HomeUserState {}

final class HomeUserInitial extends HomeUserState {}

final class HomeUserLoading extends HomeUserState {}

final class HomeUserSucess extends HomeUserState {
  List<Product> listAllProducts;
  List<Subcategory> subcategories;
  List<Category> listCategoris;
  HomeUserSucess(this.listAllProducts, this.subcategories, this.listCategoris);
}

final class HomeUserFail extends HomeUserState {}

//selected subcategory
final class HomeUsersubCategoryProductsLoading extends HomeUserState {}

final class HomeUsersubCategoryProductsSucess extends HomeUserState {
  final List<Subcategory> subcategories;

  HomeUsersubCategoryProductsSucess(this.subcategories);

  @override
  List<Object> get props => [subcategories];
}

final class HomeUsersubCategoryProductsFail extends HomeUserState {
  String error;

  HomeUsersubCategoryProductsFail(this.error);
}

//
final class HomeUserCategoryProductsLoading extends HomeUserState {}

final class HomeUserCategoryProductsSucess extends HomeUserState {
  final List<Category> categories;
  //final int cartcount;
  HomeUserCategoryProductsSucess(
    this.categories,
  );

  @override
  List<Object> get props => [categories];
}

final class HomeUserCategoryProductsFail extends HomeUserState {
  String error;
  HomeUserCategoryProductsFail(this.error);
}

//
final class HomeUserProductsLoading extends HomeUserState {}

final class HomeUserProductsSuc extends HomeUserState {
  List<Product> products;
  HomeUserProductsSuc(this.products);
}

final class HomeUserProductsFail extends HomeUserState {
  String error;
  HomeUserProductsFail(this.error);
}

final class cartCountStateHome extends HomeUserState {
  String count;
  cartCountStateHome(this.count);
}

final class UserOrderLoading extends HomeUserState {}

final class UserOrderSuccess extends HomeUserState {
  List<OrderModel> orderlist;

  UserOrderSuccess(this.orderlist);
}

final class UserOrderFail extends HomeUserState {}
