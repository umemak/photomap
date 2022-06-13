import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'UserState.dart';
import 'LoginCheck.dart';
import 'MapDetailPage.dart';
import 'MapListPage.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage(this.mapid, {Key? key}) : super(key: key);
  final String mapid;

  @override
  NewPostPageState createState() => NewPostPageState();
}

class NewPostPageState extends State<NewPostPage> {
  String mapTitle = "";

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    String dropdownValue = '01';
    if (userState.user == null) {
      return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlinedButton(
                    onPressed: () => {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const LoginCheck(
                                nextPage: MapListPage.routeName);
                          }))
                        },
                    child: const Text("ログイン", style: TextStyle(fontSize: 40)))
              ]),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("新規投稿"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: <Widget>[
                Text("${userState.user?.email}"),
                const Text("都道府県："),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: '01', child: Text('北海道')),
                    DropdownMenuItem(value: '02', child: Text('青森県')),
                  ],
                ),
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
                          .collection('posts')
                          .doc() // ドキュメントID自動生成
                          .set({
                        'author': userState.user?.email,
                        'title': mapTitle,
                        'mapid': widget.mapid,
                        'date': date
                      });
                      if (!mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return MapDetailPage(widget.mapid);
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
}
