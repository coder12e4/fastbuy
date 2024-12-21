import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
part 'image_uploading_button_state.dart';

class ImageUploadingButtonCubit extends Cubit<ImageUploadingButtonState> {
  ImageUploadingButtonCubit() : super(ImageUploadingButtonInitial());

  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://fastbuy-55678.appspot.com");
  UploadTask? uploadTask;
  final progress = 0.0;
  String? UploadUrl;

  /* Future uploadfile() async {
    final path = "images/'${platformFile!.name}'";
    final file = File(platformFile!.path!);
    final ref = await storage.ref().child(path);

    uploadTask = ref.putFile(file);

    final snapshots = await uploadTask!.whenComplete(() {});
    final downloadlink = snapshots.ref.getDownloadURL();
    uploadTask = null;
  }
*/
  Future<File?> pickImage(bool b) async {
    final pickedFile;
    if (b) {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    }
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
          'images/${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';
      print(fileName);

      final storageRef = storage.ref().child(fileName);
      final metadata = SettableMetadata(contentType: "image/jpeg");

      uploadTask = storageRef.putFile(imageFile, metadata);

      uploadTask!.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            print("Upload error: ");
            break;
          case TaskState.success:
            print("Upload complete.");
            break;
        }
      });

      await uploadTask;

      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> saveImageUrlToFirestore(
      String? imageUrl, String? subjectTypeId, String subject) async {
    try {
      await FirebaseFirestore.instance.collection('images').add({
        'category': subjectTypeId,
        'url': imageUrl,
        'uploaded_at': Timestamp.now(),
        'subject': subject
      });

      emit(ImageUploadingButtonSuccess(UploadUrl!));
    } catch (e) {
      emit(ImageUploadingButtonFailed(e.toString()));
    }
  }

  void showPicker(context, String name) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        uploadAndSaveImage("category", name, true);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      uploadAndSaveImage("category", name, false);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadAndSaveImage(
      String? subjectTypeId, String subject, bool b) async {
    File? imageFile = await pickImage(b);
    if (imageFile != null) {
      try {
        emit(ImageUploadingButtonLoading(progress));
        print(imageFile);
        final imageUrl = await uploadImageToStorage(imageFile);
        UploadUrl = imageUrl;
        if (imageUrl != null) {
          await saveImageUrlToFirestore(imageUrl, subjectTypeId, subject);
        } else {
          emit(ImageUploadingButtonFailed("Failed to upload image"));
        }
      } catch (e) {
        print(e);
        emit(ImageUploadingButtonFailed(e.toString()));
      }
    } else {
      emit(ImageUploadingButtonFailed("No image selected"));
    }
  }
}
