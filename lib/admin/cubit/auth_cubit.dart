import 'package:bloc/bloc.dart';
import 'package:fastbuy/admin/adminModels/regmodel.dart';
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

  Future<dynamic> getLoginYourShop(String userName, String Password) async {
    try {
      emit(AuthLoginLoading());
      final Person person = await authRepo.LoginAdmin(userName, Password);
      addUserId(person.id);
      emit(AuthLoginSucees());
    } catch (e) {
      print(e);
      emit(AuthLoginFail());
    }
  }

  Future<void> addUserId(String? userid) async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      userId.setString("userId", userid!);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getUserId() async {
    try {
      SharedPreferences userId = await SharedPreferences.getInstance();
      return userId.getString('userId');
    } catch (e) {
      print(e);
    }
  }
}
