import 'package:fastbuy/admin/productlistprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListCategoriesWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories, Subcategories, and Products'),
      ),
      body: categoriesAsyncValue.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (categories) {
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ExpansionTile(
                title: Text(category['category']),
                children: category['subcategories'].map<Widget>((subcategory) {
                  return ExpansionTile(
                    title: Text(subcategory['name']),
                    children: subcategory['products'].map<Widget>((product) {
                      return ListTile(
                        trailing: GestureDetector(
                          onTap: () async {
                            final firestore = ref.read(firestoreProvider);

                            await _deleteProduct(
                              firestore,
                              category['category'],
                              subcategory['name'],
                              product['id'],
                            );
                          },
                          child: Icon(Icons.delete),
                        ),
                        leading: Image.network(
                          'https://www.shutterstock.com/image-photo/broccoli-vegitable-fresh-healthy-food-260nw-2212193943.jpg',
                        ),
                        title: Text(product['name']),
                        subtitle: Text(
                          'Description: ${product['description']}\n'
                          'Price: \$${product['price']}\n'
                          'Discount: ${product['discount']}%\n'
                          'Image URL: ${product['imageUrl']}',
                        ),
                        onTap: () async {},
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteProduct(FirebaseFirestore firestore, String categoryId,
      String subcategoryId, String productId) async {
    try {
      print(categoryId);
      await firestore
          .collection('shop')
          .doc(categoryId)
          .collection('subcategories')
          .doc(subcategoryId)
          .collection('products')
          .doc(productId)
          .delete();

      print("deleted");
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}
