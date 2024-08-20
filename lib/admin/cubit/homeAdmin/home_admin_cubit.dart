import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../adminModels/addProductModel/addproduct.dart';

part 'home_admin_state.dart';

class HomeAdminCubit extends Cubit<HomeAdminState> {
  HomeAdminCubit() : super(HomeAdminInitial());
  List<Category> categories = [];
  Future<void> getCategories(String userId) async {
    try {
      emit(HomeAdminLoading());

      final categoriesSnap = await FirebaseFirestore.instance
          .collection("categories")
          .where("userId", isEqualTo: userId)
          .get();
      List<Category> categories = categoriesSnap.docs
          .map((doc) =>
              Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      List<Product?> products = await getAllProducts(userId);

      emit(HomeAdminSuccess(categories, products));
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
}
