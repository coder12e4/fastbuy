import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        'selectedSeller': "",
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
}
