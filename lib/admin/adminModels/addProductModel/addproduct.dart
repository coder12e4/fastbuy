import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String userId;
  final String image; // Add the userId property

  Category(
      {required this.id,
      required this.name,
      required this.userId,
      required this.image // Include the userId in the constructor
      });

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
        id: id,
        name: map['name'],
        userId: map['userId'],
        image: map['image'] // Map the userId from the map
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'image': image // Include userId in the map
    };
  }

  @override
  List<Object> get props => [id, name, userId, image];
}

class Subcategory extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String userId; // Add the userId property
  final String image;

  Subcategory(
      {required this.id,
      required this.name,
      required this.categoryId,
      required this.userId,
      required this.image // Include the userId in the constructor
      });

  factory Subcategory.fromMap(Map<String, dynamic> map, String id) {
    return Subcategory(
        id: id,
        name: map['name'],
        categoryId: map['categoryId'],
        userId: map['userId'],
        image: map['imageofsubcategory'] // Map the userId from the map
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'userId': userId,
      'imageofsubcategory': image // Include userId in the map
    };
  }

  @override
  List<Object> get props => [id, name, categoryId, userId, image];
}

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String categoryId;
  final String subcategoryId;
  final String userId;
  final String image;
  final String Discount;
  final String PriceAfterDiscount; // Add the userId property
  final int stock;
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.categoryId,
      required this.subcategoryId,
      required this.userId,
      required this.image,
      required this.Discount,
      required this.PriceAfterDiscount, // Include the userId in the constructor
      required this.stock});

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
        id: id,
        name: map['name'],
        price: map['price'],
        categoryId: map['categoryId'],
        subcategoryId: map['subcategoryId'],
        userId: map['userId'],
        image: map['imageofproduct'],
        Discount: map['discount'],
        PriceAfterDiscount:
            map['priceafterdiscount'] // Map the userId from the map
        ,
        stock: map['stock']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'userId': userId,
      'imageofproduct': image,
      'discount': Discount,
      'priceafterdiscount': PriceAfterDiscount, // Include userId in the map
      'stock': stock
    };
  }

  @override
  List<Object> get props => [
        id,
        name,
        price,
        categoryId,
        subcategoryId,
        userId,
        image,
        Discount,
        PriceAfterDiscount,
        stock
      ];
}

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final List<Product> products;
  final double totalPrice;
  final double discount;
  final double finalPrice;
  final String status; // e.g., 'pending', 'approved', 'shipped', etc.
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.discount,
    required this.finalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'],
      products: (map['products'] as List<dynamic>)
          .map((item) => Product.fromMap(item, item['id']))
          .toList(),
      totalPrice: map['totalPrice'].toDouble(),
      discount: map['discount'].toDouble(),
      finalPrice: map['finalPrice'].toDouble(),
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'products': products.map((product) => product.toMap()).toList(),
      'totalPrice': totalPrice,
      'discount': discount,
      'finalPrice': finalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [
        id,
        userId,
        products,
        totalPrice,
        discount,
        finalPrice,
        status,
        createdAt,
        updatedAt,
      ];
}
