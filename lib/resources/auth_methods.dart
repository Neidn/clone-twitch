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

  // get current user
  Future<model.User?> getCurrentUser() async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _userRef.doc(currentUser.uid).get();

    if (!documentSnapshot.exists) {
      return null;
    }

    return model.User.fromMap(documentSnapshot.data()!);
  }

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

      await _userRef.doc(userCredential.user!.uid).set(user.toMap());
      Provider.of<UserProvider>(context, listen: false).user = user;

      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        e.message ?? 'Something went wrong!',
      );
      return false;
    }
  }

  Future<bool> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final String emailTrim = email.trim();
      final String passwordTrim = password.trim();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailTrim,
        password: passwordTrim,
      );

      if (userCredential.user == null) {
        return false;
      }

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _userRef.doc(userCredential.user!.uid).get();

      if (!snapshot.exists) {
        return false;
      }

      model.User user = model.User.fromMap(snapshot.data()!);
      Provider.of<UserProvider>(context, listen: false).user = user;

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
