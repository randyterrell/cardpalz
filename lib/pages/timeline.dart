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
    getUsers();
    super.initState();
  }

  getUsers(){
    usersRef.getDocuments().then((QuerySnapshot snapshot){
      snapshot.documents.forEach((DocumentSnapshot doc) { 
        print(doc.data);
        print(doc.documentID);
        print(doc.exists);
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: circularProgress(),
    );
  }
}
