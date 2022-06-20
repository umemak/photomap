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
                        print(data['posts']);
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text(data['title']),
                              WebViewX(
                                key: const ValueKey('webviewx'),
                                initialContent:
                                    'http://127.0.0.1:5001/photomap-c92bb/us-central1/mapview?p01=1',
                                initialSourceType: SourceType.url,
                                height: 420,
                                width: 620,
                                onWebViewCreated: (controller) =>
                                    webviewController = controller,
                              ),
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
                  // Expanded(
                  //   child:
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('maps')
                        .doc(widget.id)
                        .collection('posts')
                        .orderBy('date')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView(
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
          ],
        ),
      ),
    );
  }
}
