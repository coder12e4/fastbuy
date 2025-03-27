import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/adminModels/regmodel.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/service/get_serverkey.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../../admin/repository/adminAuthRepository.dart';
import '../../Models/UserModel.dart';

part 'login_user_state.dart';

class LoginUserCubit extends Cubit<LoginUserState> {
  LoginUserCubit() : super(LoginUserInitial());

  Future<void> userLogin(String userName, String password) async {
    try {
      emit(LoginUserLoading());

      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      //getServerkey
      Serverkey serverkey = Serverkey();
      final servertoken = await serverkey.getServerToken();
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: userName, password: password);
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          // Save user data to SharedPreferences
          String? fcm = await FirebaseMessaging.instance.getToken();

          var userDataSnapshot = await FirebaseFirestore.instance
              .collection("users")
              .where("userId", isEqualTo: userCredential.user!.uid)
              .limit(1)
              .get();
          //  var userData = userDataSnapshot.docs.first.data()['selectedSeller']['userId'];

          DocumentReference docRef = userDataSnapshot.docs.first.reference;

          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapshot = await transaction.get(docRef);
            if (!snapshot.exists) {
              throw Exception("Document does not exist!");
            }
            transaction.update(docRef, {'userFcm': fcm});
          });

          AuthCubit authCubit = AuthCubit(adminAuthRepo(), AuthInitial());

          await authCubit.addUserId(
              userCredential.user!.uid,
              true,
              true,
              fcm,
              servertoken,
              userDataSnapshot.docs.first.data()['selectedSeller']['userId'],
              userDataSnapshot.docs.first['selectedSeller']['sellerfcm'],
              password,
              userName);
          emit(LoginUserSuccess(userCredential.user!.uid,
              userDataSnapshot.docs.first.data()['selectedSeller']['userId']));
        } else {
          emit(LoginUserFail("Email not verified. Please verify your email."));
        }
      } else {
        emit(LoginUserFail("User not found. Please check your credentials."));
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions
      if (e.code == 'user-not-found') {
        emit(LoginUserFail("No user found with this email."));
      } else if (e.code == 'wrong-password') {
        emit(LoginUserFail("Incorrect password. Please try again."));
      } else if (e.code == 'user-disabled') {
        emit(LoginUserFail("This user account has been disabled."));
      } else {
        emit(LoginUserFail("Authentication error: ${e.message}"));
      }
    } catch (e) {
      emit(LoginUserFail("An unexpected error occurred: $e"));
    }
  }

  Future<void> RegisterUser(UserModel userModel) async {
    emit(LoginUserLoading());
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential? userCredential =
          await auth.createUserWithEmailAndPassword(
              email: userModel.userName!, password: userModel.password!);

      user = userCredential.user!;

      user.sendEmailVerification();
    } catch (e) {
      print(e);
    }

    final UserData = FirebaseFirestore.instance.collection("users");

    UserData.add({
      "userName": userModel.userName,
      "password": userModel.password,
      'houseName': userModel.houseName,
      'homeNo': userModel.homeNo,
      'location': userModel.location,
      'district': userModel.district,
      'pin': userModel.district,
      'whatsAppNo': userModel.whatsAppNo,
      'contactNo2': userModel.contactNo2,
      'userId': user!.uid,
      'selectedSeller': userModel.shopmo!.toJson(),
      'street': userModel.street,
      'place': userModel.place,
      'locality': userModel.locality,
      'lat': userModel.latitude,
      'long': userModel.longitude,
      'userFcm': userModel.userFcm
    }).then((value) {
      emit(LoginUserSuccess(user!.uid, userModel.shopmo!.userId!));
    }).catchError((error) {
      emit(LoginUserFail(error.toString()));
    });
  }

  Future<void> getAllsellers() async {
    emit(LoginUserShopLoading());
    final firestore = FirebaseFirestore.instance.collection("sellers");
    QuerySnapshot snapshot = await firestore.get();

    try {
      List<shopModel> shopModelList = snapshot.docs
          .map(
            (doc) => shopModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
      emit(LoginUserShopSucess(shopModelList));
    } catch (e) {
      print(e);
      emit(LoginUserShopFail());
    }
    print("---eaquatable is loading---");
  }

  Future<void> resetPassword(String email) async {
    try {
      emit(LoginUserLoading());
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Password reset email sent
      print('Password reset email sent');
      emit(LoginUserSuccess("", ""));
    } catch (e) {
      // Handle error
      print('Failed to send password reset email: $e');
      emit(LoginUserFail(e.toString()));
    }
  }

  Future<void> getCurrentLocationDetails() async {
    String address = "Unable to get location";
    try {
      // Check if location services are enabled
      emit(loadingdeleveryLocation());
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, return an appropriate message
        String error =
            "Location services are disabled. Please enable them to get location details.";
        emit(loadingdeleveryFailed(error));
      }
      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, return an appropriate message
          String error =
              "Location permissions are denied. Please grant permissions to get location details.";
          emit(loadingdeleveryFailed(error));
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, return an appropriate message
        String error =
            "Location permissions are permanently denied. We cannot request permissions.";
        emit(loadingdeleveryFailed(error));
      }
      // Get the current position

      Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best)
          .timeout(Duration(seconds: 30));

      // Get the address from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = "${place.street},"
                " ${place.subLocality}, "
                "${place.locality}, ${place.postalCode}, "
                "${place.country}" +
            position.latitude.toString() +
            " " +
            position.longitude.toString();
        print(
            position.latitude.toString() + " " + position.longitude.toString());
        emit(loadingdeleverySuceess(
            "${place.street}",
            " ${place.subLocality},",
            "${place.locality}",
            "${place.country}",
            position.latitude.toString(),
            position.longitude.toString()));
      }
    } on TimeoutException {
      emit(loadingdeleveryFailed("Location cant fetch, try again"));
    } catch (e) {
      // Handle exceptions
      print("Error occurred while getting location: $e");
    }
  }
}
