import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserState.dart';
import 'LoginPage.dart';

class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key, required this.nextPage}) : super(key: key);
  final String nextPage;

  @override
  LoginCheckState createState() => LoginCheckState();
}

class LoginCheckState extends State<LoginCheck> {
  void checkUser() {
    final userState = Provider.of<UserState>(context, listen: false);
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    } else {
      userState.setUser(FirebaseAuth.instance.currentUser!);
      Navigator.pushReplacementNamed(context, widget.nextPage);
    }
  }

  @override
  void initState() {
    super.initState();
    Future(() {
      checkUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
