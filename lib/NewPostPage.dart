import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'UserState.dart';
import 'MapDetailPage.dart';

class NewPostPage extends StatefulWidget {
  static const routeName = '/newpost';
  const NewPostPage(this.mapid, {Key? key}) : super(key: key);
  final String mapid;

  @override
  NewPostPageState createState() => NewPostPageState();
}

class NewPostPageState extends State<NewPostPage> {
  String mapTitle = "";
  String dropdownValue = '01';

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    userState.setUser(FirebaseAuth.instance.currentUser);
    if (userState.user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              OutlinedButton(
                onPressed: () => context.go('/login'),
                child: const Text("ログイン", style: TextStyle(fontSize: 40)),
              )
            ],
          ),
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
                Text(widget.mapid),
                Row(
                  children: [
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
                        DropdownMenuItem(value: '02', child: Text('青森')),
                        DropdownMenuItem(value: '03', child: Text('岩手')),
                        DropdownMenuItem(value: '04', child: Text('宮城')),
                        DropdownMenuItem(value: '05', child: Text('秋田')),
                        DropdownMenuItem(value: '06', child: Text('山形')),
                        DropdownMenuItem(value: '07', child: Text('福島')),
                        DropdownMenuItem(value: '08', child: Text('茨城')),
                        DropdownMenuItem(value: '09', child: Text('栃木')),
                        DropdownMenuItem(value: '10', child: Text('群馬')),
                        DropdownMenuItem(value: '11', child: Text('埼玉')),
                        DropdownMenuItem(value: '12', child: Text('千葉')),
                        DropdownMenuItem(value: '13', child: Text('東京')),
                        DropdownMenuItem(value: '14', child: Text('神奈川')),
                        DropdownMenuItem(value: '15', child: Text('新潟')),
                        DropdownMenuItem(value: '16', child: Text('富山')),
                        DropdownMenuItem(value: '17', child: Text('石川')),
                        DropdownMenuItem(value: '18', child: Text('福井')),
                        DropdownMenuItem(value: '19', child: Text('山梨')),
                        DropdownMenuItem(value: '20', child: Text('長野')),
                        DropdownMenuItem(value: '21', child: Text('岐阜')),
                        DropdownMenuItem(value: '22', child: Text('静岡')),
                        DropdownMenuItem(value: '23', child: Text('愛知')),
                        DropdownMenuItem(value: '24', child: Text('三重')),
                        DropdownMenuItem(value: '25', child: Text('滋賀')),
                        DropdownMenuItem(value: '26', child: Text('京都')),
                        DropdownMenuItem(value: '27', child: Text('大阪')),
                        DropdownMenuItem(value: '28', child: Text('兵庫')),
                        DropdownMenuItem(value: '29', child: Text('奈良')),
                        DropdownMenuItem(value: '30', child: Text('和歌山')),
                        DropdownMenuItem(value: '31', child: Text('鳥取')),
                        DropdownMenuItem(value: '32', child: Text('島根')),
                        DropdownMenuItem(value: '33', child: Text('岡山')),
                        DropdownMenuItem(value: '34', child: Text('広島')),
                        DropdownMenuItem(value: '35', child: Text('山口')),
                        DropdownMenuItem(value: '36', child: Text('徳島')),
                        DropdownMenuItem(value: '37', child: Text('香川')),
                        DropdownMenuItem(value: '38', child: Text('愛媛')),
                        DropdownMenuItem(value: '39', child: Text('高知')),
                        DropdownMenuItem(value: '40', child: Text('福岡')),
                        DropdownMenuItem(value: '41', child: Text('佐賀')),
                        DropdownMenuItem(value: '42', child: Text('長崎')),
                        DropdownMenuItem(value: '43', child: Text('熊本')),
                        DropdownMenuItem(value: '44', child: Text('大分')),
                        DropdownMenuItem(value: '45', child: Text('宮崎')),
                        DropdownMenuItem(value: '46', child: Text('鹿児島')),
                        DropdownMenuItem(value: '47', child: Text('沖縄')),
                      ],
                    ),
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
                ElevatedButton(
                  child: const Text('画像'),
                  onPressed: () async {
                    PickedFile? pickerFile = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    File file = File(pickerFile!.path);

                    FirebaseStorage storage = FirebaseStorage.instance;
                    try {
                      await storage.ref("UL/upload-pic.png").putFile(file);
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: "コメント"),
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
                      context.go('/map/${widget.mapid}');
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
