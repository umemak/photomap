import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'LoginPage.dart';
import 'UserState.dart';
import 'MapListPage.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserState userState = UserState();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>.value(
      value: userState,
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        title: 'PhotoMap',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MapListPage(),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          LoginPage.routeName: (BuildContext context) => const LoginPage(),
          MapListPage.routeName: (BuildContext context) => MapListPage(),
        },
      ),
    );
  }
}
