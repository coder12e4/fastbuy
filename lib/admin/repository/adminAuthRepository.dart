import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../adminModels/regmodel.dart';

abstract class AdminAuthRepository {
  Future<Person> getPerson(AuthParams authParams);
  Future<Person> LoginAdmin(String userName, String password);
}

class adminAuthRepo extends AdminAuthRepository {
  @override
  Future<Person> getPerson(AuthParams authParams) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: authParams.email, password: authParams.password);
    User? user = userCredential.user;
    Person? person = getFirebaseuser(user);

    final addNewShop = FirebaseFirestore.instance.collection("sellers");

    addNewShop
        .add({
          "address": authParams.address,
          "contact": authParams.contact,
          "deliveryVehicleNo": authParams.deliveryVehicleNo,
          "email": authParams.email,
          "name": authParams.name,
          "seller": authParams.seller,
          "shop address": authParams.shopAddress,
          'userId': person!.id
        })
        .then((value) => print("User registration Successfull"))
        .catchError((error) => print("Failed to add user: $error"));
    return person;
  }

  Person? getFirebaseuser(User? user) {
    return user == null ? null : Person(user.uid);
  }

  @override
  Future<Person> LoginAdmin(String userName, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: userName, password: password);
    User? user = userCredential.user;
    Person? person = getFirebaseuser(user);
    return person!;
  }
}

class AuthParams {
  String email;
  String password;
  String name;
  bool seller;
  String address;
  String contact;
  String deliveryVehicleNo;
  String shopAddress;
  String userId;

  AuthParams(this.email, this.password, this.name, this.seller, this.address,
      this.contact, this.deliveryVehicleNo, this.shopAddress, this.userId);
}

class LoginUser {
  String user_name;
  String password;
  LoginUser(this.user_name, this.password);
}
