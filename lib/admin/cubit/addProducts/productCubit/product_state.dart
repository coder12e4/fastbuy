part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoding extends ProductState {}

final class ProductCreationSuccess extends ProductState {}

final class ProductCreationFailed extends ProductState {
  String error;
  ProductCreationFailed(this.error);
}

final class statePiceAfterDiscount extends ProductState {
  double PriceAfterDiscount;
  statePiceAfterDiscount(this.PriceAfterDiscount);
}

final class ProductsListLoding extends ProductState {}

final class ProductsListSucess extends ProductState {
  List<Product> product;
  ProductsListSucess(this.product);
}

final class ProductsListFail extends ProductState {}
