import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/addProducts/productCubit.dart';

class ProductPage extends StatelessWidget {
  final String categoryId;
  final String subcategoryId;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  ProductPage({required this.categoryId, required this.subcategoryId});

  void _addProduct(BuildContext context) async {
    String? userId = await context.read<AuthCubit>().getUserId();
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: '',
        name: _nameController.text,
        price: double.parse(_priceController.text),
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        userId: userId!,
      );
      context.read<ProductCubit>().addProduct(product);
      _nameController.clear();
      _priceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProductCubit>().fetchProducts(categoryId, subcategoryId);

    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a product name' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Product Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a product price' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () => _addProduct(context),
                      child: Text('Add Product')),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductCubit, List<Product>>(
              builder: (context, products) {
                if (products.isEmpty) {
                  return Center(child: Text('No products'));
                }
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('\$${product.price}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
