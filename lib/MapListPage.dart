import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserState.dart';

class MapListPage extends StatefulWidget {
  static const routeName = '/maps';

  const MapListPage({Key? key}) : super(key: key);
  @override
  MapListPageState createState() => MapListPageState();
}

class MapListPageState extends State<MapListPage> {
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("地図一覧"),
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Text("${userState.user!.email}"),
                ElevatedButton(
                  onPressed: () => context.go('/newmap'),
                  child: const Text("新規地図作成"),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('maps')
                  // .where('author', isEqualTo: widget.user.email)
                  .orderBy('date')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView(
                    children: documents.map((document) {
                      return Card(
                        child: ListTile(
                          title: Text(document['title']),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_right),
                            onPressed: () => context.go('/map/${document.id}'),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return const Center(
                  child: Text("読込中..."),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
