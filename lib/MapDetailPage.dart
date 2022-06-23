import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';
import 'package:sprintf/sprintf.dart';
import 'package:crop_your_image/crop_your_image.dart';

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
  final _cropController = CropController();
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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text("地図詳細"),
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(child: Text("Header")),
            ListTile(
              title: Text("Item 1"),
            ),
            ListTile(
              title: Text("Item 2"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/newpost/${widget.id}'),
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  FutureBuilder<DocumentSnapshot>(
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
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text(data['title']),
                              // Text(widget.id),
                            ],
                          ),
                        );
                      }
                      // データが読込中の場合
                      return const Center(
                        child: Text('読込中...'),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Expanded(
            // child:
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('maps')
                  .doc(widget.id)
                  .collection('posts')
                  .orderBy('date', descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  Map<String, int> pc = {};
                  int pp = 0;
                  for (var d in documents) {
                    String p = d['prefCd'];
                    if (pc.containsKey(p)) {
                      pc[p] = pc[p]! + 1;
                    } else {
                      pc[p] = 1;
                      pp++;
                    }
                  }
                  final Size size = MediaQuery.of(context).size;
                  final double width = size.width;
                  final double height = width * 0.6;
                  String url =
                      // "http://127.0.0.1:5001/photomap-c92bb/us-central1/mapview?";
                      "https://us-central1-photomap-c92bb.cloudfunctions.net/mapview?";
                  url += "width=${width * 0.97}&height=${height * 0.97}";
                  pc.forEach(((key, value) => url = "$url&p$key=$value"));
                  return Column(
                    children: [
                      WebViewX(
                        key: const ValueKey('webviewx'),
                        initialContent: url,
                        initialSourceType: SourceType.url,
                        height: height,
                        width: width,
                        onWebViewCreated: (controller) =>
                            webviewController = controller,
                      ),
                      Text(sprintf("%d/47 達成", [pp])),
                      Text(sprintf("投稿数：%d件", [documents.length])),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: documents.map((document) {
                          return Card(
                            child: ListTile(
                              title: Text(document['title']),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_right),
                                onPressed: () =>
                                    context.go('/map/${document.id}'),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  );
                }
                return const Center(
                  child: Text(""),
                );
              },
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
