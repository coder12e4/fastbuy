part of 'image_uploading_button_cubit.dart';

@immutable
sealed class ImageUploadingButtonState {}

final class ImageUploadingButtonInitial extends ImageUploadingButtonState {}

final class ImageUploadingButtonLoading extends ImageUploadingButtonState {}

final class ImageUploadingButtonSuccess extends ImageUploadingButtonState {}

final class ImageUploadingButtonFailed extends ImageUploadingButtonState {
  String error;

  ImageUploadingButtonFailed(this.error);
}
