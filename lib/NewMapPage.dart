import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'MapListPage.dart';

class NewMapPage extends StatefulWidget {
  const NewMapPage(this.user);
  final User user;

  @override
  NewMapPageState createState() => NewMapPageState();
}

class NewMapPageState extends State<NewMapPage> {
  String testTitle = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規地図"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              Text("${widget.user.email}"),
              TextFormField(
                decoration: const InputDecoration(labelText: "タイトル"),
                onChanged: (String value) {
                  setState(() {
                    testTitle = value;
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
                      'author': widget.user.email,
                      'title': testTitle,
                      'date': date
                    });
                    if (!mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return MapListPage();
                      }),
                    );
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
