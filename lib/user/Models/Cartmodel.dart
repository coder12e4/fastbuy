import 'package:equatable/equatable.dart';
import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';

class CartModel extends Equatable {
  final String id;
  final Product product;
  final String quantity;
  final String price;
  final String productId;

  CartModel(
      {required this.id,
      required this.product,
      required this.quantity,
      required this.price,
      required this.productId});

  factory CartModel.fromMap(Map<String, dynamic> map, String id) {
    return CartModel(
        product:
            Product.fromMap(map['product'], map['product']['subcategoryId']),
        quantity: map['quantity'],
        price: map['price'],
        id: map["userId"],
        productId: map['productId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'price': price,
      "userId": id,
      "productId": productId
    };
  }

  @override
  List<Object> get props => [product, quantity, price, id, productId];
}
