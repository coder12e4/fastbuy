import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';

class ProductCubit extends Cubit<List<Product>> {
  ProductCubit() : super([]);

  void fetchProducts(String categoryId, String subcategoryId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('subcategoryId', isEqualTo: subcategoryId)
        .get();

    List<Product> products = snapshot.docs
        .map((doc) =>
            Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    emit(products);
  }

  void fetchAll(String catogoryid, String? usrId) async {
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
          .get();

      products = snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      emit(products);
    }
  }

  void addProduct(Product product) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap());

      product = Product(
          id: docRef.id,
          name: product.name,
          price: product.price,
          categoryId: product.categoryId,
          subcategoryId: product.subcategoryId,
          userId: product.userId);
      emit([...state, product]);
    } catch (e) {
      print(e);
    }
  }
}
