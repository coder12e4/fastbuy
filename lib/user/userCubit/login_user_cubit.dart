import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../Models/UserModel.dart';

part 'login_user_state.dart';

class LoginUserCubit extends Cubit<LoginUserState> {
  LoginUserCubit() : super(LoginUserInitial());
  Future<void> userLogin(String userName, String password) async {
    try {
      emit(LoginUserLoading());
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: userName, password: password);
      User? user = userCredential.user;
      if (user!.emailVerified) {
        emit(LoginUserSuccess());
      } else {
        emit(LoginUserFail());
      }
    } catch (e) {
      emit(LoginUserFail());
      print(e);
    }
  }

  Future<void> RegisterUser(UserModel userModel) async {
    emit(LoginUserLoading());
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential? userCredential =
          await auth.createUserWithEmailAndPassword(
              email: userModel.UserName, password: userModel.Password);
      user = userCredential.user!;
      user.sendEmailVerification();
    } catch (e) {
      print(e);
    }

    final UserData = FirebaseFirestore.instance.collection("users");

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
      'userId': user!.uid,
    }).then((value) {
      emit(LoginUserSuccess());
    }).catchError((error) {
      emit(LoginUserFail());
    });
  }
}
