import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/models/user.dart' as user_model;
import 'package:social_media_app/resources/storage_provider.dart';
import 'package:social_media_app/utils/strings.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<user_model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _fireStore.collection("users").doc(currentUser.uid).get();
    return user_model.User.fromSnap(snapshot);
  }

  signUpUser({
    required String email,
    required String password,
    required String bio,
    required String userName,
    required Uint8List file,
  }) async {
    String res = Strings.some_error_occured;
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          userName.isNotEmpty ||
          file != null) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //add user to our database

        String downloadUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //add user
        user_model.User user = user_model.User.name(
          email,
          cred.user!.uid,
          downloadUrl,
          userName,
          bio,
          [],
          [],
        );

        await _fireStore.collection("users").doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "Success";
      }
    } catch (err) {
      res = res.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = Strings.some_error_occured;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        FirebaseAuth _auth = FirebaseAuth.instance;
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = Strings.SUCCESS;
      } else {
        res = 'Please enter all the field';
      }
    } catch (er) {
      res = er.toString();
    }
    return res;
  }

  Future<String> signOutUser() async {
    String res = Strings.some_error_occured;
    try {
      _auth.signOut();
      res = 'Successfully Logout';
      return res;
    } catch (e) {
      return res;
    }
  }
}
