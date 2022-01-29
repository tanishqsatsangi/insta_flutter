import 'package:flutter/material.dart';
import 'package:social_media_app/models/user.dart' as models;
import 'package:social_media_app/resources/auth_provider.dart';

class UserProvider extends ChangeNotifier {
  models.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  models.User get getUser => _user!;

  Future<void> refreshUser() async {
    try {
      models.User user = await _authMethods.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (err) {
      print("err on refresh user $err");
    }
  }
}
