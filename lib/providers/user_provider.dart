import 'package:flutter/material.dart';

import '/resources/auth_methods.dart';

import '/models/user.dart';

class UserProvider extends ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();

  User _user = User(
    uid: '',
    username: '',
    email: '',
  );

  User get user {
    if (_user.uid == '' && _user.username == '' && _user.email == '') {
      _authMethods.getCurrentUser().then((user) {
        _user = user!;
        notifyListeners();
      });
    }

    return _user;
  }

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  void refreshUser(User user) {
    _user = user;
    notifyListeners();
  }
}
