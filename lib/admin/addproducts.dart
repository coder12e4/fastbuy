import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class addproducts extends ConsumerStatefulWidget {
  const addproducts({super.key});

  @override
  addproductsState createState() => addproductsState();
}

class addproductsState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Create New Category",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            AddUser("dd", "ddd", 23)
          ],
        ),
      ),
    );
  }
}

class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
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

    return ElevatedButton(
      onPressed: addCategory,
      child: const Text(
        "Add User",
      ),
    );
  }
}
