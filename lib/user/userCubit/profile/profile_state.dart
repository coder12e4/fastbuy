part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  UserModel userModel;

  ProfileSuccess(this.userModel);
}

final class ProfileFail extends ProfileState {}

final class EditProfileInitial extends ProfileState {}

final class EditProfileLoading extends ProfileState {}

final class EditProfileSuccess extends ProfileState {}

final class EditProfileFail extends ProfileState {}
