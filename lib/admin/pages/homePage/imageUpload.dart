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
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      });

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    setState(() {
      platformFile = result.files.first;
    });
  }

  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (platformFile!.path != null)
            Image.file(
              File(platformFile!.path!),
              height: 100,
              width: 100,
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
          const SizedBox(
            height: 32,
          ),
          Text("$error"),
          buildPrograss(),
          ElevatedButton(
              onPressed: () {
                uploadfile();
              },
              child: const Center(
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
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      selectFile();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    selectFile();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
