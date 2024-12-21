import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/adminModels/addProductModel/addproduct.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/Cartmodel.dart';

part 'home_user_state.dart';

class HomeUserCubit extends Cubit<HomeUserState> {
  HomeUserState homeUserState;
  StreamSubscription? _categorySubscription;
  StreamSubscription? _subcategorySubscription;
  StreamSubscription? _CartSubsription;

  HomeUserCubit(this.homeUserState) : super(HomeUserInitial());
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> GetProductsbycatogorysubcategory(
      String categoryId, String SubcategoryId) async {
    try {
      List<Product> list;
      emit(HomeUserProductsLoading());
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('subcategoryId', isEqualTo: SubcategoryId)
          .get();

      list = querySnapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      print('product list lenth');
      print(list.length);
      emit(HomeUserProductsSuc(list));
    } catch (e) {
      emit(HomeUserProductsFail(e.toString()));
    }
  }

  Future<void> fetchOrdersByUserId(String userId) async {
    emit(UserOrderLoading());
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      final orders = querySnapshot.docs
          .map((doc) =>
              OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      emit(UserOrderSuccess(orders));
    } catch (e) {}
  }

  void fetchCategories(String sellerId, String userId) async {
    emit(HomeUserCategoryProductsLoading());
    try {
      _categorySubscription = _firestore
          .collection('categories')
          .where("userId", isEqualTo: sellerId)
          .snapshots()
          .listen((querySnapshot) {
        final category = querySnapshot.docs
            .map((doc) =>
                Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        emit(HomeUserCategoryProductsSucess(category));
      });
    } catch (e) {
      emit(HomeUserCategoryProductsFail(e.toString()));
    }
  }

  void fetchSubCategories(String categoryId) {
    emit(HomeUsersubCategoryProductsLoading());
    try {
      _subcategorySubscription = _firestore
          .collection('subcategories')
          .where('categoryId', isEqualTo: categoryId)
          .snapshots()
          .listen((query) {
        final subcategories = query.docs
            .map((doc) =>
                Subcategory.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        emit(HomeUsersubCategoryProductsSucess(subcategories));
      });
    } catch (e) {
      emit(HomeUsersubCategoryProductsFail(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences userdata = await SharedPreferences.getInstance();
      await userdata.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> close() {
    _categorySubscription?.cancel();
    _subcategorySubscription?.cancel();
    _CartSubsription?.cancel();
    return super.close();
  }

  void loadProductsformSearch(String searchQuery, String? sellerId) async {
    print("sellerId" + sellerId!);
    print("productname" + searchQuery!);
    try {
      List<Product> list = [];
      emit(HomeUserProductsLoading());
      list.clear();
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('userId', isEqualTo: sellerId)
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .get();

      list = querySnapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      print('product list lenth');
      print(list.length);
      emit(HomeUserProductsSuc(list));
    } catch (e) {
      print('Error occurred: $e');

      // Check if error is related to Firestore indexing
      if (e is FirebaseException && e.message != null) {
        final errorMessage = e.message!;
        if (errorMessage.contains('FAILED_PRECONDITION') &&
            errorMessage.contains('index')) {
          print('Firestore indexing error: $errorMessage');
          emit(HomeUserProductsFail(
              'Firestore indexing error: Please create the required index in the Firestore console.'));
        } else {
          emit(HomeUserProductsFail(errorMessage));
        }
      } else {
        emit(HomeUserProductsFail(e.toString()));
      }
    }
  }

  Future<void> getCartByuserId(String userId) async {
    try {
      _CartSubsription = FirebaseFirestore.instance
          .collection("cart")
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((querysnapshots) {
        final kartModel = querysnapshots.docs
            .map((doc) =>
                CartModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        // Emit CartSuccess state with the list of cart items
        emit(cartCountStateHome(kartModel.length.toString()));
      });
    } catch (e) {}
  }

  Stream<int> getCartByuserIds(String userId) {
    // Create a StreamController to manage the cart count stream
    StreamController<int> cartCountController = StreamController<int>();

    try {
      // Listen to Firestore snapshots
      _CartSubsription = FirebaseFirestore.instance
          .collection("cart")
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((querySnapshots) {
        // Map querySnapshots to a list of CartModel
        List<CartModel> kartModel = querySnapshots.docs.map((doc) {
          return CartModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        // Add the cart count to the stream
        cartCountController.add(kartModel.length);
      });
    } catch (e) {
      // Handle any errors
      cartCountController.addError(e);
    }

    // Return the stream
    return cartCountController.stream;
  }
}
