import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../adminModels/addProductModel/addproduct.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<List<Product>> fetchProducts(
      String categoryId, String subcategoryId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('subcategoryId', isEqualTo: subcategoryId)
        .get();

    List<Product> products = snapshot.docs
        .map((doc) =>
            Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return products;
  }

  void deleteProduct(String categoryId, String subcategoryId, String userId,
      String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      print("Product deleted successfully");
      fetchAll(subcategoryId, categoryId, userId);
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  void fetchAll(String SubcategoryId, String catogoryid, String? usrId) async {
    emit(ProductsListLoding());
    List<Product> products = [];
    if (catogoryid == "") {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where("userId", isEqualTo: usrId)
          .get();

      products = snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } else {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('categoryId', isEqualTo: catogoryid)
          .where('subcategoryId', isEqualTo: SubcategoryId)
          .get();

      products = snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      emit(ProductsListSucess(products));
    }
  }

  void MoveToInitial() {
    emit(ProductInitial());
  }

  void calculatePriceAfterDiscount(double price, double discount) {
    double priceafterdiscount = price - (price * discount / 100);
    emit(statePiceAfterDiscount(priceafterdiscount));
  }

  void addProduct(Product product) async {
    try {
      emit(ProductLoding());
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap());

      product = Product(
          id: docRef.id,
          name: product.name,
          price: product.price,
          categoryId: product.categoryId,
          subcategoryId: product.subcategoryId,
          userId: product.userId,
          image: product.image,
          Discount: product.Discount,
          PriceAfterDiscount: product.PriceAfterDiscount,
          stock: product.stock,
          QuantityType: product.QuantityType);

      emit(ProductCreationSuccess());
    } catch (e) {
      emit(ProductCreationFailed(e.toString()));
      print(e);
    }
  }

  void updateStock(String productId, int quantityPurchased) {
    Future.microtask(() async {
      try {
        //     emit(StockUpdating());
        DocumentReference docRef =
            FirebaseFirestore.instance.collection('products').doc(productId);

        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(docRef);

          if (!snapshot.exists) {
            throw Exception("Product does not exist!");
          }

          int currentStock = snapshot.get('stock');
          int updatedStock = currentStock - quantityPurchased;

          if (updatedStock < 0) {
            throw Exception("Not enough stock available!");
          }

          transaction.update(docRef, {'stock': updatedStock});
        });

        //  emit(StockUpdateSuccess());
      } catch (e) {
        //   emit(StockUpdateFailed(e.toString()));
        print("Error updating stock: $e");
      }
    });
  }
}
