import 'package:flutter/material.dart';

import '/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    uid: '',
    username: '',
    email: '',
  );

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }
}
