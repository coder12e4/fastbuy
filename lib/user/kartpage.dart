import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) => ListTile(
          leading: Image.network(""),
          title: Text(""),
          subtitle: Text(""),
          trailing: IconButton(
            icon: const Icon(Icons.remove_shopping_cart),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
