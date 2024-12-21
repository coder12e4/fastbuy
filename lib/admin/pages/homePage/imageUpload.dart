import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploads extends StatefulWidget {
  ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  PlatformFile? platformFile = PlatformFile(name: "test", size: 0);
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://fastbuy-55678.appspot.com");
  UploadTask? uploadTask;
  FirebaseAuth mAuth = FirebaseAuth.instance;
  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print('Failed to sign in anonymously: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    signInAnonymously();
    super.initState();
  }

  Future uploadfile() async {
    final path = "images/'${platformFile!.name}'";
    final file = File(platformFile!.path!);
    final ref = await storage.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshots = await uploadTask!.whenComplete(() {});
    final downloadlink = snapshots.ref.getDownloadURL();

    setState(() {
      uploadTask = null;
    });
  }

  Widget buildPrograss() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double prograss = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 20,
            width: 100,
            child: Stack(
              children: [
                LinearProgressIndicator(
                  value: prograss,
                  backgroundColor: Colors.black26,
                  color: Colors.yellow,
                ),
                Center(
                  child: Text(
                    '${(100 * prograss).roundToDouble()}%',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      });

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    setState(() {
      platformFile = result.files.first;
    });
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String? error;
/*
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
*/

/*
  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'images/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$destination');
      await ref.putFile(_photo!);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      print('error occured');
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (platformFile!.path != null)
            Container(
              child: Image.file(
                File(platformFile!.path!),
                height: 100,
                width: 100,
              ),
            ),
          GestureDetector(
            onTap: () {
              selectFile();
            },
            child: Container(
              height: 100,
              width: 100,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Text("$error"),
          buildPrograss(),
          ElevatedButton(
              onPressed: () {
                uploadfile();
              },
              child: Center(
                child: Text("Upload"),
              ))
        ],
      ),
    );
  }

  void _showPicker(context) {
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
                        selectFile();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      selectFile();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
