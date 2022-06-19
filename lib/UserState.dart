import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  void setUser(User? newUser) {
    user = newUser;
    notifyListeners();
  }
}
