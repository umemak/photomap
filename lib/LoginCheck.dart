import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserState.dart';

class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key, required this.nextPage}) : super(key: key);
  final String nextPage;

  @override
  LoginCheckState createState() => LoginCheckState();
}

class LoginCheckState extends State<LoginCheck> {
  void checkUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userState = Provider.of<UserState>(context, listen: false);
    if (currentUser == null) {
      context.go('/login');
    } else {
      userState.setUser(currentUser);
      context.go(widget.nextPage);
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
