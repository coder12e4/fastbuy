import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../adminModels/addProductModel/addproduct.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  void fetchCategories(String userId) async {
    emit(CategoryAddLoading());
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("userId", isEqualTo: userId)
        .get();
    List<Category> categories = snapshot.docs
        .map(
          (doc) => Category.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
    emit(CategorySuccess(categories));
  }

  void addCategory(Category category, String userid) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('categories')
          .add(category.toMap());
      category = Category(id: docRef.id, name: category.name, userId: userid);
      fetchCategories(userid);
    } catch (e) {
      print(e);
    }
  }
}
