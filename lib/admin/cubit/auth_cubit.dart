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
      final Person person = await authRepo.getPerson(authParams);

      emit(AuthRegitrationSucees());
    } catch (e) {
      print(e);
      emit(AuthRegitrationFail());
    }
  }

  Future<dynamic> getLoginYourShop(
      String userName, String Password, fcm) async {
    try {
      emit(AuthLoginLoading());
      final Person person = await authRepo.LoginAdmin(userName, Password);

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
        serverkey.getServerToken().then((valuee) async {
          await addUserId(person.id, false, true, fcm, valuee, "", "");
        });
        emit(AuthLoginSucees());
      }
    } catch (e) {
      print(e);
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
      String? sellerfcm) async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      userId.setString("userId", userid! ?? "");
      userId.setBool("userType", UserType! ?? false);
      userId.setBool("islogin", isloagin! ?? false);
      userId.setString("fcm", fcm! ?? "");
      userId.setString("serverkey", serverkey! ?? "");
      if (UserType) {
        userId.setString("sellerId", sellerId! ?? "");
        userId.setString("sellerfcm", sellerfcm! ?? "");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> getBool(String key) async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      return userId.getBool(key);
    } catch (e) {
      print(e);
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
      print(e);
      return "";
    }
  }

  Future<String?> getString(String key) async {
    try {
      SharedPreferences value = await SharedPreferences.getInstance();
      return value.getString(key);
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences userdata = await SharedPreferences.getInstance();
      await userdata.clear();
    } catch (e) {
      print(e);
    }
  }
}
