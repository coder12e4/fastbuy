import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/kartitem.dart';
import '../models/product.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    if (!state.contains(
      CartItem(product: product, quantity: 0).product.id,
    )) {
      print("product already in kart");
    } else {
      state = [
        ...state,
        CartItem(product: product, quantity: 1),
      ];
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }
}
