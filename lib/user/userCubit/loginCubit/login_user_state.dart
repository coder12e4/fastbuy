part of 'login_user_cubit.dart';

@immutable
sealed class LoginUserState {}

final class LoginUserInitial extends LoginUserState {}

final class LoginUserShopLoading extends LoginUserState {}

final class LoginUserShopSucess extends LoginUserState {
  List<shopModel> shopModelList;

  LoginUserShopSucess(this.shopModelList);
}

final class LoginUserShopFail extends LoginUserState {}

final class LoginUserLoading extends LoginUserState {}

final class LoginUserSuccess extends LoginUserState {
  String userId;
  String sellerId;
  LoginUserSuccess(this.userId, this.sellerId);
}

final class LoginUserFail extends LoginUserState {
  final String error;
  LoginUserFail(this.error);
}

final class changePasswordinitital extends LoginUserState {}

final class changePasswordLoding extends LoginUserState {}

final class changePasswordSucess extends LoginUserState {}

final class changePasswordFail extends LoginUserState {}

final class loadingdeleveryLocation extends LoginUserState {}

final class loadingdeleverySuceess extends LoginUserState {
  final String street;
  final String subLocality;
  final String locality;
  final String country;
  final String latitude;
  final String longitude;

  loadingdeleverySuceess(this.street, this.subLocality, this.locality,
      this.country, this.latitude, this.longitude);
}

final class loadingdeleveryFailed extends LoginUserState {
  final String error;

  loadingdeleveryFailed(this.error);
}
