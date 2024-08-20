import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String userId; // Add the userId property

  Category({
    required this.id,
    required this.name,
    required this.userId, // Include the userId in the constructor
  });

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'],
      userId: map['userId'], // Map the userId from the map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId, // Include userId in the map
    };
  }

  @override
  List<Object> get props => [id, name, userId];
}

class Subcategory extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String userId; // Add the userId property

  Subcategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.userId, // Include the userId in the constructor
  });

  factory Subcategory.fromMap(Map<String, dynamic> map, String id) {
    return Subcategory(
      id: id,
      name: map['name'],
      categoryId: map['categoryId'],
      userId: map['userId'], // Map the userId from the map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'userId': userId, // Include userId in the map
    };
  }

  @override
  List<Object> get props => [id, name, categoryId, userId];
}

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String categoryId;
  final String subcategoryId;
  final String userId; // Add the userId property

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.subcategoryId,
    required this.userId, // Include the userId in the constructor
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'],
      price: map['price'],
      categoryId: map['categoryId'],
      subcategoryId: map['subcategoryId'],
      userId: map['userId'], // Map the userId from the map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'userId': userId, // Include userId in the map
    };
  }

  @override
  List<Object> get props =>
      [id, name, price, categoryId, subcategoryId, userId];
}
