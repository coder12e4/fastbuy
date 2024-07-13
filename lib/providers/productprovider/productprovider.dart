import 'dart:convert';

import 'package:fastbuy/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/ProductList.dart';
import '../../models/product.dart';
import 'package:http/http.dart' as http;

final productsProvider = Provider<List<Product>>((ref) {
  return [
    Product(
      id: '1',
      name: 'Product 1',
      description: 'Description 1',
      price: 29.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '2',
      name: 'Product 2',
      description: 'Description 2',
      price: 19.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    // Add more products as needed
  ];
});

final futureprovider = FutureProvider<ProductList>((ref) async {
  try {
    var jsonData = await ApiServices(
            "https://mocki.io/v1/19acd5a5-fbfe-46af-8f8f-a6482a00af55")
        .getData();
    return ProductList.fromJson(jsonData);
  } catch (e) {
    print(e);
    return null!;
  }
});
