import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserState.dart';
import 'NewMapPage.dart';
import 'MapListPage.dart';
import 'LoginCheck.dart';

class NewMapConfirmPage extends StatefulWidget {
  const NewMapConfirmPage(this.user);
  final User user;
  static const routeName = '/map_confirm';
  @override
  NewMapConfirmPageState createState() => NewMapConfirmPageState();
}

class NewMapConfirmPageState extends State<NewMapConfirmPage> {
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    if (userState.user != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("地図作成確認"),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text("${userState.user!.email}"),
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return NewMapConfirmPage(userState.user!);
                        }),
                      ),
                    },
                    child: const Text("確認"),
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
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return ListView(
                      children: documents.map((document) {
                        return Card(
                          child: ListTile(
                            title: Text(document['title']),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_right),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return MapDetailPage(document.id);
                                  }),
                                );
                              },
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
    } else {
      return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlinedButton(
                    onPressed: () => {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return LoginCheck(
                                nextPage: NewMapConfirmPage.routeName);
                          }))
                        },
                    child: const Text("ログイン", style: TextStyle(fontSize: 40)))
              ]),
        ),
      );
    }
  }
}
