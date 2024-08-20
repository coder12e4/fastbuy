import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming you have a Firestore provider
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final addCategoryProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  final firestore = ref.read(firestoreProvider);
  await firestore.collection('shop').add(data);
});

final updateProductProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final firestore = ref.read(firestoreProvider);
  await firestore.collection('shop').doc(params['categoryId']).update({
    'subcategories': FieldValue.arrayUnion([params['subcategory']])
  });
});

final deleteProductProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final firestore = ref.read(firestoreProvider);
  await firestore.collection('shop').doc(params['categoryId']).update({
    'subcategories': FieldValue.arrayRemove([params['subcategory']])
  });
});

/*
class firebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Groups>> todoStream(String? serach) {
    return firestore
        .collection("homedata")
        .where(serach!)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Groups> retVal = [];
      retVal.clear();
      query.docs.forEach((element) {
        retVal.add(Groups.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }
}
*/

class FirebaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('shop');

  Future<void> addCategory() {
    // Call the user's CollectionReference to add a new user
    CollectionReference shops = FirebaseFirestore.instance.collection('shop');
    // CollectionReference categories =  shops.doc("shop1").collection('categories');
    // CollectionReference products = categories.doc("category1").collection('vegitables');
    return shops
        .add({
          'full_name': "tomato", // John Doe
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    CollectionReference shops = FirebaseFirestore.instance.collection('shop');
    CollectionReference categories =
        shops.doc("shop1").collection('categories');
    CollectionReference products =
        categories.doc("category1").collection('vegitables');

    return products
        .add({
          'full_name': "tomato", // John Doe
          'company': "good tomatos", // Stokes and Sons
          'price': 13 // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /* Stream<List<Groups>> todoStream(String? serach) {
    return firestore
        .collection("homedata")
        .where(serach!)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Groups> retVal = [];
      retVal.clear();
      query.docs.forEach((element) {
        retVal.add(Groups.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }*/
}
