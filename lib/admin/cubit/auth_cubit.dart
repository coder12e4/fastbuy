import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/adminModels/regmodel.dart';
import 'package:fastbuy/service/get_serverkey.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/adminAuthRepository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  adminAuthRepo authRepo;
  AuthState state;
  AuthCubit(this.authRepo, this.state) : super(state);

  Future<dynamic> getRegisterYourShop(AuthParams authParams) async {
    try {
      emit(AuthRegistrationLoading());
      await authRepo.getPerson(authParams);
      emit(AuthRegitrationSucees());
    } catch (e) {
      print(e);
      emit(AuthRegitrationFail());
    }
  }

  Future<dynamic> getLoginYourShop(
      String userName, String password, String fcm) async {
    try {
      emit(AuthLoginLoading());

      final Person person = await authRepo.LoginAdmin(userName, password);

      QuerySnapshot personSnapshot = await FirebaseFirestore.instance
          .collection('sellers')
          .where('userId', isEqualTo: person.id)
          .limit(1)
          .get();

      if (personSnapshot.docs.isEmpty) {
        emit(AuthLoginFail("User does not exist"));
        return;
      } else {
        Serverkey serverkey = Serverkey();
        DocumentReference docRef = personSnapshot.docs.first.reference;
        await docRef.update({
          'sellerfcm': fcm,
          //'lastLoginTime': FieldValue.serverTimestamp(), // example field update
          // Add any other fields you need to update here
        });
        // Fetch and use the server token
        String serverToken = await serverkey.getServerToken();
        await addUserId(person.id, false, true, fcm, serverToken, "", "",
            password, userName);

        emit(AuthLoginSucees(person.id));
      }
    } catch (e) {
      emit(AuthLoginFail(e.toString()));
    }
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
    } catch (e) {}
  }

  Future<bool?> getBool(String? key) async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      return userId.getBool(key!) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getSellerId() async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      return userId.getString('sellerId');
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<String?> getUserId() async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      return userId.getString('userId');
    } catch (e) {
      return "";
    }
  }

  Future<String?> getUserName() async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      return userId.getString('username321');
    } catch (e) {
      return "";
    }
  }

  Future<String?> getUserPassword() async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      return userId.getString('password321');
    } catch (e) {
      return "";
    }
  }

  Future<String?> getString(String key) async {
    try {
      SharedPreferences value = await SharedPreferences.getInstance();
      return value.getString(key);
    } catch (e) {
      return "";
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences userdata = await SharedPreferences.getInstance();
      await userdata.clear();
    } catch (e) {}
  }
}
