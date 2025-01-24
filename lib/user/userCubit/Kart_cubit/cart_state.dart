part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  List<CartModel> listCartUser;
  CartSuccess(this.listCartUser);
}

final class BookingIsLoading extends CartState {}

final class BookingIsSuccess extends CartState {}

final class BookingIsFailed extends CartState {}

final class CartFail extends CartState {
  String error;
  CartFail(this.error);
}
