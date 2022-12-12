import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/UI/auth/login_screen.dart';
import 'package:flutter_firebase/UI/firestore/firestore_list_screen.dart';
import 'package:flutter_firebase/UI/posts/post_screen.dart';
import 'package:flutter_firebase/UI/upload_image.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadImageScreen(),
              )));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              )));
    }
  }
}
