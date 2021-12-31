import 'package:cardpalz/widgets/header.dart';
import 'package:cardpalz/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    // getUserById();
    // createUser();
    // updateUser();
    deleteUser();
    super.initState();
  }

  createUser() {
    usersRef
        .document("asdfasfd")
        .setData({"username": "Jeff", "postsCount": 0, "isAdmin": false});
  }

  updateUser() async {
    final doc = await usersRef.document("NFWpxQshn5DSkpZE3m8o").get();
    if (doc.exists) {
      doc.reference
          .updateData({"username": "John", "postsCount": 0, "isAdmin": false});
    }
  }

  deleteUser() async {
    final DocumentSnapshot doc =
        await usersRef.document("NFWpxQshn5DSkpZE3m8o").get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  // getUserById() async {
  //   final String id = "NdgXrzZy2kywY67PEkSw";
  //   final DocumentSnapshot doc = await usersRef.document(id).get();
  //   print(doc.data);
  //   print(doc.documentID);
  //   print(doc.exists);
  // }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final List<Text> children = snapshot.data.documents
              .map((doc) => Text(doc['username']))
              .toList();
          return Container(
            child: ListView(
              children: children,
            ),
          );
        },
      ),
    );
  }
}