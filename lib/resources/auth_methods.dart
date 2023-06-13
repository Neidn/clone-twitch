import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/utils.dart';
import '/utils/constants.dart';

import '/models/user.dart' as model;

import '/providers/user_provider.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> _userRef =
      FirebaseFirestore.instance.collection(
    usersCollection,
  );

  Future<bool> signUpUser({
    required BuildContext context,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final String emailTrim = email.trim();
      final String usernameTrim = username.trim();
      final String passwordTrim = password.trim();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailTrim,
        password: passwordTrim,
      );

      if (userCredential.user == null) {
        return false;
      }

      model.User user = model.User(
        uid: userCredential.user!.uid,
        username: usernameTrim,
        email: emailTrim,
      );

      _userRef.doc(userCredential.user!.uid).set(user.toMap()).then((_) {
        Provider.of<UserProvider>(context, listen: false).user = user;
      });
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        e.message ?? 'Something went wrong!',
      );
      return false;
    }
  }
}
