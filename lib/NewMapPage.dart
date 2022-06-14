import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'UserState.dart';
import 'MapListPage.dart';

class NewMapPage extends StatefulWidget {
  static const routeName = '/newmap';
  const NewMapPage({Key? key}) : super(key: key);

  @override
  NewMapPageState createState() => NewMapPageState();
}

class NewMapPageState extends State<NewMapPage> {
  String mapTitle = "";

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    if (userState.user == null) {
      return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlinedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text("ログイン", style: TextStyle(fontSize: 40)))
              ]),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("新規地図"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: <Widget>[
                Text("${userState.user?.email}"),
                TextFormField(
                  decoration: const InputDecoration(labelText: "タイトル"),
                  onChanged: (String value) {
                    setState(() {
                      mapTitle = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('作成'),
                    onPressed: () async {
                      final date =
                          DateTime.now().toLocal().toIso8601String(); // 現在の日時
                      await FirebaseFirestore.instance
                          .collection('maps')
                          .doc() // ドキュメントID自動生成
                          .set({
                        'author': userState.user?.email,
                        'title': mapTitle,
                        'date': date
                      });
                      if (!mounted) return;
                      context.go('/maps');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
