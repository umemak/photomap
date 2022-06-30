import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';
import 'package:sprintf/sprintf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

import 'UserState.dart';
import 'pref_codes.dart';
import 'models/post_model.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/newpost/${widget.id}'),
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                          child: Text(''),
                        );
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('maps')
                    .doc(widget.id)
                    .collection('posts')
                    .orderBy('createdAt', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
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
                    final double width = (size.width > 800) ? 800 : size.width;
                    final double height = width * 0.6;
                    String url =
                        // "http://127.0.0.1:5001/photomap-c92bb/us-central1/mapview?";
                        "https://us-central1-photomap-c92bb.cloudfunctions.net/mapview?";
                    url += "width=${width * 0.9}&height=${height * 0.9}";
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
                      ],
                    );
                  }
                  return const Center(
                    child: Text("読込中..."),
                  );
                },
              ),
              ChangeNotifierProvider(
                create: (_) => PostsModel()..getPosts(widget.id),
                child: Consumer<PostsModel>(
                  builder: (context, model, child) {
                    final posts = model.posts;
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: posts.map((post) {
                        return listItemBuilder(post: post);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItemBuilder({
    required PostModel post,
  }) {
    return GestureDetector(
      onTap: () async {
        var result = await showModalBottomSheet<int>(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(post.title),
                const SizedBox(height: 8),
                SizedBox(
                  width: 400,
                  height: 400,
                  child: imageWidget(post.imageURL),
                ),
                const SizedBox(height: 8),
                IconButton(
                    onPressed: () => {},
                    icon: Icon(
                      Icons.favorite_outline,
                      color: Colors.pink,
                    )),
              ],
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 3),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: imageWidget(post.imageURL),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 100,
                child: mainContent(
                  post: post,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(String url) {
    Image img = Image.asset('assets/no_image_square.jpg');
    if (url != "") {
      img = Image.network(url);
    }
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: img,
      ),
    );
  }

  Widget mainContent({
    required PostModel post,
  }) {
    initializeDateFormatting("ja_JP");
    DateTime datetime = post.createdAt.toDate();
    var formatter = DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    var formatted = formatter.format(datetime);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(PrefCodes.cdToName(post.prefCd)),
        const SizedBox(height: 4),
        Row(
          children: [
            tagText(text: "飲", enabled: post.cate00),
            const SizedBox(width: 8),
            tagText(text: "食", enabled: post.cate01),
            const SizedBox(width: 8),
            tagText(text: "酒", enabled: post.cate02),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          formatted,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget tagText({String text = "", bool enabled = false}) {
    return Container(
      color: enabled ? Colors.blue : Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
          color: enabled ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
