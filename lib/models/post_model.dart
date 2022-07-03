import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostModel {
  String ID;
  String author;
  bool cate00;
  bool cate01;
  bool cate02;
  String comment;
  Timestamp createdAt;
  String imageURL;
  String thumbnailURL;
  String mapID;
  String prefCd;
  String title;

  PostModel(
    this.ID,
    this.author,
    this.cate00,
    this.cate01,
    this.cate02,
    this.comment,
    this.createdAt,
    this.imageURL,
    this.thumbnailURL,
    this.mapID,
    this.prefCd,
    this.title,
  );
}

class PostsModel extends ChangeNotifier {
  List<PostModel> posts = [];

  Future getPosts(String mapID) async {
    final collection = await FirebaseFirestore.instance
        .collection('maps')
        .doc(mapID)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get();
    final posts = collection.docs
        .map((doc) => PostModel(
              doc.id,
              doc['author'],
              doc['cate00'],
              doc['cate01'],
              doc['cate02'],
              doc['comment'],
              doc['createdAt'],
              doc['imageURL'],
              doc['thumbnailURL'],
              doc['mapID'],
              doc['prefCd'],
              doc['title'],
            ))
        .toList();
    this.posts = posts;
    notifyListeners();
  }
}
