part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  List<CartModel> listCartUser;
  CartSuccess(this.listCartUser);
}

final class CartFail extends CartState {
  String error;
  CartFail(this.error);
}
