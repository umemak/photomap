import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';

import 'NewPostPage.dart';
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
                            label: const Text('投稿'),
                            onPressed: () =>
                                context.go('/newpost/${widget.id}'),
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
