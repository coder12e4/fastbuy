import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/admin/repository/adminAuthRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin/adminModels/regmodel.dart';
import '../service/get_serverkey.dart';

part 'spash_state.dart';

class SpashCubit extends Cubit<SpashState> {
  SpashCubit() : super(SpashInitial());
  adminAuthRepo authRepo = adminAuthRepo();

  void screenDirrection() async {
    emit(SpashLoding());
    try {
      AuthCubit authCubit = AuthCubit(adminAuthRepo(), AuthInitial());
      bool? islogins = await authCubit.getBool('islogin');
      bool? userType = await authCubit.getBool('userType');
      String? password = await authCubit.getUserPassword();
      String? username = await authCubit.getUserName();

      if (islogins != null && islogins) {
        if (userType!) {
          FirebaseMessaging.instance.getToken().then((fcmtoken) {
            userLogin(username!, password!, fcmtoken!);
          });
        } else {
          FirebaseMessaging.instance.getToken().then((fcmtoken) {
            getLoginYourShop(username!, password!, fcmtoken!);
          });
        }
      } else {
        emit(SpashError());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> getLoginYourShop(
      String userName, String password, String fcm) async {
    try {
      final Person person = await authRepo.LoginAdmin(userName, password);
      QuerySnapshot personSnapshot = await FirebaseFirestore.instance
          .collection('sellers')
          .where('userId', isEqualTo: person.id)
          .limit(1)
          .get();

      if (personSnapshot.docs.isEmpty) {
        return;
      } else {
        DocumentReference docRef = personSnapshot.docs.first.reference;
        await docRef.update({
          'sellerfcm': fcm,
        });

        emit(SpashAdminSuccess(person.id));
      }
    } catch (e) {
      print("Error: $e");
      emit(SpashError());
    }
  }

  Future<void> userLogin(
      String userName, String password, String fcmtoken) async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: userName, password: password);
      User? user = userCredential.user;
      if (user != null) {
        if (user.emailVerified) {
          // Save user data to SharedPreferences
          var userDataSnapshot = await FirebaseFirestore.instance
              .collection("users")
              .where("userId", isEqualTo: user.uid)
              .limit(1)
              .get();
          var userData = userDataSnapshot.docs.first.data();
          final String sellerId = userData['selectedSeller']['userId'];

          emit(SpashSuccess(user.uid, sellerId));
        } else {}
      } else {}
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions
      if (e.code == 'user-not-found') {
        //      emit(LoginUserFail("No user found with this email."));
      } else if (e.code == 'wrong-password') {
        //    emit(LoginUserFail("Incorrect password. Please try again."));
      } else if (e.code == 'user-disabled') {
        //   emit(LoginUserFail("This user account has been disabled."));
      } else {
        //  emit(LoginUserFail("Authentication error: ${e.message}"));
      }
    } catch (e) {}
  }

  Future<void> addUserId(
      String? userid,
      bool? UserType,
      bool? isloagin,
      String? fcm,
      String? serverkey,
      String? sellerId,
      String? sellerfcm,
      String? password,
      String? username) async {
    try {
      SharedPreferences userPref = await SharedPreferences.getInstance();
      userPref.setString("userPref", userid! ?? "");
      userPref.setBool("userType", UserType! ?? false);
      userPref.setBool("islogin", isloagin! ?? false);
      userPref.setString("fcm", fcm! ?? "");
      userPref.setString("serverkey", serverkey! ?? "");
      userPref.setString("password321", password! ?? "");
      userPref.setString("username321", username! ?? "");

      if (UserType) {
        userPref.setString("sellerId", sellerId! ?? "");
        userPref.setString("sellerfcm", sellerfcm! ?? "");
      }
    } catch (e) {
      print(e);
    }
  }
}
