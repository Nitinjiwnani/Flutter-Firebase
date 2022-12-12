import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool _loading = false;
  File? _image;
  final picker = ImagePicker();
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Center(child: Icon(Icons.image)),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RoundButton(
              title: 'Upload',
              onTap: () async {
                setState(() {
                  _loading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/foldername/' +
                        DateTime.now().millisecondsSinceEpoch.toString());
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute);
                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();
                  databaseRef.child('1').set({
                    'id': '1212',
                    'title': newUrl.toString(),
                  }).then((value) {
                    setState(() {
                      _loading = false;
                    });
                    Utils().toastMessage('Uploaded');
                  }).onError((error, stackTrace) {
                    setState(() {
                      _loading = false;
                    });
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    _loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              })
        ],
      ),
    );
  }
}
