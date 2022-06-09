import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';

import 'UserState.dart';

class MapDetailPage extends StatefulWidget {
  static const routeName = '/map';
  const MapDetailPage(this.id, {Key? key}) : super(key: key);
  final String id;

  @override
  MapDetailPageState createState() => MapDetailPageState();
}

class MapDetailPageState extends State<MapDetailPage> {
  late WebViewXController webviewController;
  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("地図詳細"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('maps')
                    .doc(widget.id)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('エラー'),
                    );
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return const Center(
                      child: Text('指定した地図が見つかりません'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    // final _titleController = TextEditingController.fromValue(
                    //     TextEditingValue(text: data['title'] ?? ""));
                    // var _qTitleController = []..length = 11;
                    // var _qItem1Controller = []..length = 11;
                    // var _qItem2Controller = []..length = 11;
                    // var _qItem3Controller = []..length = 11;
                    // var _qItem4Controller = []..length = 11;
                    // var _qAnswerController = []..length = 11;
                    // var _qNoteController = []..length = 11;
                    // for (var i = 1; i <= 10; i++) {
                    //   var ii = "q" + i.toString().padLeft(2, "0");
                    //   _qTitleController[i] = TextEditingController.fromValue(
                    //       TextEditingValue(text: data[ii + 'Title'] ?? ""));
                    //   _qItem1Controller[i] = TextEditingController.fromValue(
                    //       TextEditingValue(text: data[ii + 'Item1'] ?? ""));
                    //   _qItem2Controller[i] = TextEditingController.fromValue(
                    //       TextEditingValue(text: data[ii + 'Item2'] ?? ""));
                    //   _qItem3Controller[i] = TextEditingController.fromValue(
                    //       TextEditingValue(text: data[ii + 'Item3'] ?? ""));
                    //   _qItem4Controller[i] = TextEditingController.fromValue(
                    //       TextEditingValue(text: data[ii + 'Item4'] ?? ""));
                    //   _qAnswerController[i] = TextEditingController.fromValue(
                    //       TextEditingValue(text: data[ii + 'Answer'] ?? ""));
                    //   _qNoteController[i] = TextEditingController.fromValue(
                    //       TextEditingValue(text: data[ii + 'Note'] ?? ""));
                    // }
                    // TextFormField makeTextFormField(
                    //     String l, TextEditingController c) {
                    //   return TextFormField(
                    //     decoration: InputDecoration(labelText: l),
                    //     controller: c,
                    //     keyboardType: TextInputType.multiline,
                    //     maxLines: null,
                    //     readOnly: true,
                    //   );
                    // }

                    // Card makeCard(int idx) {
                    //   return Card(
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           padding: const EdgeInsets.all(8),
                    //           color: Theme.of(context).primaryColor,
                    //           width: double.infinity,
                    //           child: Text("${idx.toString()}問目",
                    //               style: Theme.of(context)
                    //                   .primaryTextTheme
                    //                   .bodyText1),
                    //         ),
                    //         makeTextFormField("問題文", _qTitleController[idx]),
                    //         makeTextFormField("選択肢1", _qItem1Controller[idx]),
                    //         makeTextFormField("選択肢2", _qItem2Controller[idx]),
                    //         makeTextFormField("選択肢3", _qItem3Controller[idx]),
                    //         makeTextFormField("選択肢4", _qItem4Controller[idx]),
                    //         makeTextFormField("正解", _qAnswerController[idx]),
                    //         makeTextFormField("解説", _qNoteController[idx]),
                    //       ],
                    //     ),
                    //   );
                    // }

                    return Column(
                      children: <Widget>[
                        // Text("${userState.user!.email}"),
                        // TextFormField(
                        //   decoration: const InputDecoration(labelText: "タイトル"),
                        //   controller: _titleController,
                        // ),
                        // const SizedBox(height: 8),
                        // if (_qTitleController[1].text != "") makeCard(1),
                        // if (_qTitleController[2].text != "") makeCard(2),
                        // if (_qTitleController[3].text != "") makeCard(3),
                        // if (_qTitleController[4].text != "") makeCard(4),
                        // if (_qTitleController[5].text != "") makeCard(5),
                        // if (_qTitleController[6].text != "") makeCard(6),
                        // if (_qTitleController[7].text != "") makeCard(7),
                        // if (_qTitleController[8].text != "") makeCard(8),
                        // if (_qTitleController[9].text != "") makeCard(9),
                        // if (_qTitleController[10].text != "") makeCard(10),
                        WebViewX(
                          key: const ValueKey('webviewx'),
                          initialContent:
                              'http://127.0.0.1:5001/photomap-c92bb/us-central1/mapview?p01=1',
                          initialSourceType: SourceType.url,
                          height: 400,
                          width: 600,
                          onWebViewCreated: (controller) =>
                              webviewController = controller,
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('編集'),
                            onPressed: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(builder: (context) {
                              //     return EditTestPage(widget.id);
                              //   }),
                              // );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.share),
                            label: const Text("開催"),
                            onPressed: () async {
                              final code = Random().nextInt(100000).toString();
                              final ref = await FirebaseFirestore.instance
                                  .collection('games')
                                  .add({
                                "code": code,
                                "status": 0,
                                "test": widget.id,
                              });
                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(builder: (context) {
                              //   return SharePage(widget.id,
                              //       _titleController.text, code, ref.id);
                              // }));
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  // データが読込中の場合
                  return const Center(
                    child: Text('読込中...'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
