import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as ximage;
import 'package:image_cropper/image_cropper.dart';
import 'cropper/ui_helper.dart'
    if (dart.library.io) 'cropper/mobile_ui_helper.dart'
    if (dart.library.html) 'cropper/web_ui_helper.dart';

import 'UserState.dart';

class NewPostPage extends StatefulWidget {
  static const routeName = '/newpost';
  const NewPostPage(this.mapid, {Key? key}) : super(key: key);
  final String mapid;

  @override
  NewPostPageState createState() => NewPostPageState();
}

class NewPostPageState extends State<NewPostPage> {
  String postTitle = "";
  String prefCd = '00';
  List<bool> cateCds = [false, false, false, false];
  String uploadedPhotoUrl = "";
  String comment = "";
  String imageURL = "";
  String thumbnailURL = "";
  String imagePath = "";
  Uint8List imageData = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規投稿"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              userState.setUser(null);
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
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
                      value: prefCd,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          prefCd = newValue!;
                        });
                      },
                      items: prefDropdownMenuItems(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "カテゴリ：",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            spacing: 5.0,
                            runSpacing: 5.0,
                            children: [
                              createChoiceChip(context, "飲", 0),
                              createChoiceChip(context, "食", 1),
                              createChoiceChip(context, "酒", 2),
                              // : （省略）
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "タイトル"),
                  onChanged: (String value) {
                    setState(() {
                      postTitle = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                selectedImage(),
                ElevatedButton(
                  child: const Text('画像選択'),
                  onPressed: () async {
                    XFile? pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      CroppedFile? croppedFile = await ImageCropper().cropImage(
                        sourcePath: pickedFile.path,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                        ],
                        uiSettings: buildUiSettings(context),
                      );
                      if (croppedFile != null) {
                        final FirebaseStorage storage =
                            FirebaseStorage.instance;
                        final Uint8List imgdata =
                            await croppedFile.readAsBytes();
                        setState(() {
                          imagePath = pickedFile.path;
                          imageData = imgdata;
                        });
                        try {
                          final reference = storage
                              .ref()
                              .child("files/${basename(imagePath)}");
                          await reference
                              .putData(
                            imageData,
                            SettableMetadata(contentType: 'image'),
                          )
                              .whenComplete(() async {
                            await reference.getDownloadURL().then((value) {
                              setState(() {
                                imageURL = value;
                              });
                              if (kDebugMode) {
                                print(value);
                              }
                            });
                          });
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: "コメント"),
                  onChanged: (String value) {
                    setState(() {
                      comment = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('作成'),
                    onPressed: () async {
                      // thumbnail
                      final FirebaseStorage storage = FirebaseStorage.instance;
                      final referencetn = storage
                          .ref()
                          .child("files/tn/${basename(imagePath)}");
                      final tnData = ximage.encodePng(ximage.copyResize(
                          ximage.decodeImage(imageData)!,
                          width: 100));
                      await referencetn
                          .putData(
                        Uint8List.fromList(tnData),
                        SettableMetadata(contentType: 'image'),
                      )
                          .whenComplete(() async {
                        await referencetn.getDownloadURL().then((value) {
                          setState(() {
                            thumbnailURL = value;
                          });
                          if (kDebugMode) {
                            print(value);
                          }
                        });
                      });

                      await FirebaseFirestore.instance
                          .collection('maps')
                          .doc(widget.mapid)
                          .collection('posts')
                          .doc() // ドキュメントID自動生成
                          .set({
                        'author': userState.user?.email,
                        'title': postTitle,
                        'mapID': widget.mapid,
                        'prefCd': prefCd,
                        'cate00': cateCds[0],
                        'cate01': cateCds[1],
                        'cate02': cateCds[2],
                        'comment': comment,
                        'imageURL': imageURL,
                        'thumbnailURL': thumbnailURL,
                        'createdAt': FieldValue.serverTimestamp()
                      });
                      if (!mounted) return;
                      context.go('/map/${widget.mapid}');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ChoiceChip createChoiceChip(BuildContext context, String label, int index) {
    return ChoiceChip(
      avatar: cateCds[index]
          ? const Icon(Icons.check_box_outlined)
          : const Icon(Icons.check_box_outline_blank),
      label: Text(label),
      selected: cateCds[index],
      onSelected: (value) {
        setState(() {
          cateCds[index] = value;
        });
      },
      selectedColor: Colors.blueAccent,
      labelStyle:
          TextStyle(color: cateCds[index] ? Colors.white : Colors.black),
    );
  }

  Widget selectedImage() {
    if (imagePath == "") {
      return const Text("ファイルを選択してください");
    } else {
      return Image.memory(
        imageData,
        height: 300,
      );
    }
  }

  List<DropdownMenuItem<String>>? prefDropdownMenuItems() {
    return const [
      DropdownMenuItem(value: '00', child: Text('--選択してください--')),
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
    ];
  }
}
