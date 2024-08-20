import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../Models/UserModel.dart';

part 'login_user_state.dart';

class LoginUserCubit extends Cubit<LoginUserState> {
  LoginUserCubit() : super(LoginUserInitial());

  Future<void> RegisterUser(UserModel userModel) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    UserCredential? userCredential = await auth.createUserWithEmailAndPassword(
        email: userModel.UserName, password: userModel.Password);
    User user = userCredential.user!;
    final UserData = firestore.collection("users");

    UserData.add({
      "userName": userModel.UserName,
      "password": userModel.Password,
      'houseName': userModel.HouseName,
      'homeNo': userModel.HomeNo,
      'location': userModel.location,
      'district': userModel.District,
      'pin': userModel.District,
      'whatsAppNo': userModel.whatsAppNo,
      'contactNo2': userModel.ContactNo2,
      'userId': user.uid,
    })
        .then((value) => print("User registration Successfull"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
