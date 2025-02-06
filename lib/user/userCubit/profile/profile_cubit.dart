import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../Models/UserModel.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getProfile(String userId) async {
    emit(ProfileLoading());
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("users")
          .where("userId", isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming user data is stored in the first document
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        UserModel userModel = UserModel.fromJson(userData);
        print("User Data: ${querySnapshot.docs.first.data()}");
        emit(ProfileSuccess(userModel));
      } else {
        print("No user found with the given userId.");
        emit(ProfileFail());
      }
    } catch (e) {
      print(e);
    }
  }

  void editProfileInitial() {
    emit(EditProfileInitial());
  }

  Future<void> UpdateProfile(String UserId) async {
    emit(EditProfileLoading());
    try {
      QuerySnapshot personSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: UserId)
          .limit(1)
          .get();
      DocumentReference docRef = personSnapshot.docs.first.reference;
      docRef.update({
        "userName": "updated username",
        "password": "updated password", // Avoid storing plaintext passwords
        'houseName': "updated housename",
        'homeNo': "updated house no",
        'location': "up",
        'district': "up",
        'pin': "up",
        'whatsAppNo': "",
        'contactNo2': "",
        'street': "",
        'place': "",
        'locality': " ",
        'lat': "",
        'long': ""
      }).then((v) {
        emit(EditProfileSuccess());
      });
    } catch (e) {
      emit(EditProfileFail());
    }
  }

  Future<Position?> getCurrentLocationDetails() async {
    String address = "Unable to get location";
    Placemark? place;
    Position? position;
    try {
      // Check if location services are enabled

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, return an appropriate message
        String error =
            "Location services are disabled. Please enable them to get location details.";
      }
      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, return an appropriate message
          String error =
              "Location permissions are denied. Please grant permissions to get location details.";
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, return an appropriate message
        String error =
            "Location permissions are permanently denied. We cannot request permissions.";
      }
      // Get the current position

      position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best)
          .timeout(Duration(seconds: 30));

      // Get the address from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        place = placemarks[0];
      }
    } on TimeoutException {
    } catch (e) {
      // Handle exceptions
      print("Error occurred while getting location: $e");
    }
    return position;
  }
}
