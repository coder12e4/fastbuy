part of 'home_admin_cubit.dart';

@immutable
sealed class HomeAdminState {}

final class HomeAdminInitial extends HomeAdminState {}

final class HomeAdminLoading extends HomeAdminState {}

final class HomeAdminSuccess extends HomeAdminState {
  List<Category> categories;
  List<Product?> products;
  HomeAdminSuccess(this.categories, this.products);
}

final class HomeAdminFailed extends HomeAdminState {}
