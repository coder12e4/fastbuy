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
  AuthCubit authCubit = AuthCubit(adminAuthRepo(), AuthInitial());
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void screenDirection() async {
    emit(SpashLoding());
    try {
      final islogins = await authCubit.getBool('islogin');

      if (islogins != null && islogins) {
        // Execute multiple asynchronous tasks in parallel
        final results = await Future.wait([
          authCubit.getBool('userType'),
          authCubit.getUserPassword(),
          authCubit.getUserName(),
          FirebaseMessaging.instance.getToken(),
        ]);

        final userType = results[0] as bool?;
        final password = results[1] as String?;
        final username = results[2] as String?;
        final fcmToken = results[3] as String?;

        if (userType == true && username != null && password != null) {
          userLogin(username, password, fcmToken);
        } else if (userType == false && username != null && password != null) {
          getLoginYourShop(username, password, fcmToken!);
        } else {
          emit(SpashError());
        }
      } else {
        emit(SpashError());
      }
    } catch (e) {
      emit(SpashError());
      debugPrint(e.toString());
    }
  }

  Future<void> getLoginYourShop(
      String userName, String password, String fcm) async {
    try {
      // Fetch the admin user and the seller's document concurrently
      final personFuture = authRepo.LoginAdmin(userName, password);
      final sellerQueryFuture = FirebaseFirestore.instance
          .collection('sellers')
          .where('userId', isEqualTo: (await personFuture).id)
          .limit(1)
          .get();

      // Resolve both Futures
      final person = await personFuture;
      final sellerQuery = await sellerQueryFuture;

      // Check if the seller exists
      if (sellerQuery.docs.isNotEmpty) {
        // Update the FCM token for the seller
        final docRef = sellerQuery.docs.first.reference;
        await docRef.update({'sellerfcm': fcm});

        // Emit success with the person ID
        emit(SpashAdminSuccess(person.id));
      } else {
        emit(SpashError()); // Emit error if no seller found
      }
    } catch (e) {
      debugPrint("Error in getLoginYourShop: $e");
      emit(SpashError()); // Emit error on failure
    }
  }

  Future<void> userLogin(
      String? userName, String? password, String? fcmtoken) async {
    try {
      UserCredential? userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: userName!, password: password!);

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          // Save user data to SharedPreferences
          var userDataSnapshot = await FirebaseFirestore.instance
              .collection("users")
              .where("userId", isEqualTo: userCredential.user!.uid)
              .limit(1)
              .get();
          //var userData = userDataSnapshot.docs.first.data();
          final String sellerId =
              userDataSnapshot.docs.first.data()['selectedSeller']['userId'];
          emit(SpashSuccess(userCredential.user!.uid, sellerId));
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
      String? userId,
      bool? userType,
      bool? isLogin,
      String? fcm,
      String? serverKey,
      String? sellerId,
      String? sellerFcm,
      String? password,
      String? username) async {
    try {
      final userPref = await SharedPreferences.getInstance();

      // Collect all key-value pairs into a map
      final userData = {
        "userPref": userId ?? "",
        "userType": userType ?? false,
        "islogin": isLogin ?? false,
        "fcm": fcm ?? "",
        "serverkey": serverKey ?? "",
        "password321": password ?? "",
        "username321": username ?? "",
      };

      // Add seller-specific data if userType is true
      if (userType == true) {
        userData.addAll({
          "sellerId": sellerId ?? "",
          "sellerfcm": sellerFcm ?? "",
        });
      }

      // Batch write all data to SharedPreferences
      for (final entry in userData.entries) {
        if (entry.value is String) {
          await userPref.setString(entry.key, entry.value as String);
        } else if (entry.value is bool) {
          await userPref.setBool(entry.key, entry.value as bool);
        }
      }
    } catch (e) {
      debugPrint("Error in addUserId: $e");
    }
  }
}
