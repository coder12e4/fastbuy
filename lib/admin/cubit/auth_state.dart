part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthRegistrationLoading extends AuthState {}

final class AuthRegitrationSucees extends AuthState {}

final class AuthRegitrationFail extends AuthState {}

final class AuthLoginInitial extends AuthState {}

final class AuthLoginLoading extends AuthState {}

final class AuthLoginSucees extends AuthState {}

final class AuthLoginFail extends AuthState {}
