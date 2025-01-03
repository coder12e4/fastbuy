part of 'spash_cubit.dart';

@immutable
sealed class SpashState {}

final class SpashInitial extends SpashState {}

final class SpashLoding extends SpashState {}

final class SpashSuccess extends SpashState {
  String userId;
  String sellerId;

  SpashSuccess(this.userId, this.sellerId);
}

final class SpashAdminSuccess extends SpashState {
  String sellerId;

  SpashAdminSuccess(this.sellerId);
}

final class SpashError extends SpashState {}
