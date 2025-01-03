import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/cubit/addProducts/productCubit/product_cubit.dart';
import 'package:fastbuy/admin/cubit/addProducts/subCategoryCubit/subcategory_cubit.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/user/userCubit/homeUserCubit/home_user_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../adminModels/addProductModel/addproduct.dart';

part 'home_admin_state.dart';

class HomeAdminCubit extends Cubit<HomeAdminState> {
  HomeAdminCubit() : super(HomeAdminInitial());
  List<Category> categories = [];
  ProductCubit productCubit = ProductCubit();

  //declare stream subscription
  late StreamSubscription _CategorisStreams;
  late StreamSubscription _SubcategoryStreams;
  late StreamSubscription _ProductStreams;
  late StreamSubscription _getOrders;

  Future<void> getCategories(String userId) async {
    try {
      emit(HomeAdminLoading());

      _CategorisStreams = await FirebaseFirestore.instance
          .collection("categories")
          .where("userId", isEqualTo: userId)
          .snapshots()
          .listen((querySnapshot) {
        List<Category> categories = querySnapshot.docs
            .map((doc) => Category.fromMap(doc.data(), doc.id))
            .toList();
        emit(HomeAdminSuccess(
          categories,
        ));
      });
    } catch (e) {
      HomeAdminFailed();
    }
  }

  Future<void> logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.clear();
  }

  void getProducts(String categoryId, String subcategoryId) async {
    emit(LoadProductsLoading());
    try {
      List<Product> products =
          await productCubit.fetchProducts(categoryId, subcategoryId);
      emit(LoadProductsSuccess(products));
    } catch (e) {
      emit(LoadProductsFailed(e.toString()));
    }
  }

  Future<void> getSubcategoris(String userId, String categoryId) async {
    try {
      emit(LoadSubcategorisLoding());

      _SubcategoryStreams = await FirebaseFirestore.instance
          .collection("subcategories")
          .where("categoryId", isEqualTo: categoryId)
          .snapshots()
          .listen((snapShots) {
        List<Subcategory> subcategories = snapShots.docs
            .map((doc) =>
                Subcategory.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        emit(LoadSubcategorisSuccess(
          subcategories,
        ));
      });
    } catch (e) {
      HomeAdminFailed();
    }
  }

  Future<List<Product?>> getAllProducts(String userId) async {
    List<Product?> products = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: userId)
          .get();

      products = snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return products;
    } catch (e) {
      return products;
    }
  }

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    await FirebaseFirestore.instance.collection('images').add({
      'url': imageUrl,
      'uploaded_at': Timestamp.now(),
    });
  }

  Future<void> uploadAndSaveImage() async {
    File? imageFile = await pickImage();
    if (imageFile != null) {
      String? imageUrl = await uploadImageToStorage(imageFile);
      if (imageUrl != null) {
        await saveImageUrlToFirestore(imageUrl);
        print('Image uploaded and URL saved to Firestore.');
      } else {
        print('Failed to upload image.');
      }
    }
  }

  Future<void> fetchOrdersByUserId(String userId) async {
    // emit(UserOrderLoading());
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      _getOrders = await _firestore
          .collection('orders')
          .where('marchantId', isEqualTo: userId)
          .snapshots().listen((snapShots){
        final orders = snapShots.docs
            .map((doc) =>
            OrderModel.fromMap(doc.data(), doc.id))
            .toList();
        // emit(UserOrderSuccess(orders));

      });

    } catch (e) {}
  }

  void loadProductsformSearch(String searchQuery, String? sellerId) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      List<Product> list = [];
      emit(LoadProductsLoading());
      list.clear();
      if (searchQuery.isEmpty) {
        list = [];
      } else {
        QuerySnapshot querySnapshot = await _firestore
            .collection('products')
            .where('userId', isEqualTo: sellerId)
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .get();
        list = querySnapshot.docs.map((doc) {
          return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      }

      emit(LoadProductsSuccess(list));
    } catch (e) {
      print('Error occurred: $e');

      // Check if error is related to Firestore indexing
      if (e is FirebaseException && e.message != null) {
        final errorMessage = e.message!;
        if (errorMessage.contains('FAILED_PRECONDITION') &&
            errorMessage.contains('index')) {
          print('Firestore indexing error: $errorMessage');
          emit(LoadProductsFailed('Firestore indexing error: $errorMessage'));
        } else {
          emit(LoadProductsFailed('Firestore indexing error: $errorMessage'));
        }
      } else {
        emit(LoadProductsFailed('Firestore indexing error:'));
      }
    }
  }

  @override
  Future<void> close() {
    _CategorisStreams.cancel();
    _SubcategoryStreams.cancel();
    _ProductStreams.cancel();
    return super.close();
  }
}
