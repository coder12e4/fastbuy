import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
part 'image_uploading_button_state.dart';

class ImageUploadingButtonCubit extends Cubit<ImageUploadingButtonState> {
  ImageUploadingButtonCubit() : super(ImageUploadingButtonInitial());

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}${imageFile.path.split('.').last}';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Await the task to complete and check for errors.
      await uploadTask.whenComplete(() {
        print("Upload complete");
      }).catchError((error) {
        // Handle any errors that occur during upload.
        throw error;
      });

      // Get the download URL if the upload is successful.
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      // Emit the error state if something goes wrong.
      emit(ImageUploadingButtonFailed(e.toString()));
      return null;
    }
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('images').add({
        'url': imageUrl,
        'uploaded_at': Timestamp.now(),
      });
      emit(ImageUploadingButtonSuccess());
    } catch (e) {
      emit(ImageUploadingButtonFailed(e.toString()));
    }
  }

  Future<File?> uploadAndSaveImage() async {
    File? imageFile = await pickImage();
    if (imageFile != null) {
      emit(ImageUploadingButtonLoading());
      String? imageUrl = await uploadImageToStorage(imageFile);
      print(imageUrl!);
      await saveImageUrlToFirestore(imageUrl);
    } else {
      emit(ImageUploadingButtonFailed("image null"));
    }
  }
}
