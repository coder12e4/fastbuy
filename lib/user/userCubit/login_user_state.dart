part of 'login_user_cubit.dart';

@immutable
sealed class LoginUserState {}

final class LoginUserInitial extends LoginUserState {}

final class LoginUserLoading extends LoginUserState {}

final class LoginUserSuccess extends LoginUserState {}

final class LoginUserFail extends LoginUserState {}
