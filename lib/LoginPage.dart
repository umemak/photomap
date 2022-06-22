import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'SignupPage.dart';
import 'MapListPage.dart';
import 'UserState.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String loginUserEmail = "";
  String loginUserPassword = "";
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ログイン"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "メールアドレス"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.signInWithEmailAndPassword(
                      email: loginUserEmail,
                      password: loginUserPassword,
                    );
                    // ログインに成功した場合
                    final User user = result.user!;
                    userState.setUser(user);
                    setState(() {
                      infoText = "ログインOK：${user.email}";
                    });
                    if (!mounted) return;
                    context.go('/maps');
                  } catch (e) {
                    // ログインに失敗した場合
                    setState(() {
                      infoText = "ログインNG：${e.toString()}";
                    });
                  }
                },
                child: const Text("ログイン"),
              ),
              const SizedBox(height: 8),
              Text(infoText),
              OutlinedButton(
                  onPressed: () => {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const SignupPage();
                        }))
                      },
                  child: const Text("利用登録"))
            ],
          ),
        ),
      ),
    );
  }
}
