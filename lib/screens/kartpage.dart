import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/kartprovider.dart';

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef watch) {
    final cart = watch.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: Image.network(cart[i].product.imageUrl),
          title: Text(cart[i].product.name),
          subtitle: Text('Quantity: ${cart[i].quantity}'),
          trailing: IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            onPressed: () {
              watch.read(cartProvider.notifier).removeFromCart(cart[i].product);
            },
          ),
        ),
      ),
    );
  }
}
