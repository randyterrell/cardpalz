import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cardpalz/pages/home.dart';
import 'package:cardpalz/widgets/header.dart';
import 'package:cardpalz/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;


final chatRef = Firestore.instance.collection('chats');


class Chats extends StatefulWidget {
  String chatId;
  final String idFrom;
  final String idTo;
  final String content;

  Chats({
    this.chatId,
    this.idFrom,
    this.idTo,
    this.content,    
    });

  @override
  _ChatsState createState() => _ChatsState(
        chatId: this.chatId,
        idFrom: this.idFrom,
        idTo: this.idTo,
        content: this.content,
      );
}

class _ChatsState extends State<Chats> {
  TextEditingController chatController = TextEditingController();
  String chatId;
  final String idFrom;
  final String idTo;
  final String content;

  _ChatsState({
    this.chatId,
    this.idFrom,
    this.idTo,
    this.content
  });

  buildChat() {
    return StreamBuilder(
        stream: chatRef
            .document(chatId)
            .collection('chats')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<_Chats> chats = [];
          snapshot.data.documents.forEach((doc) {
            chats.add(_Chats.fromDocument(doc));
          });
          return ListView(
            children: chats,
          );
        });
  }

  addChat() {
    if (idFrom.compareTo(idTo) > 0) {
      chatId = '$idFrom-$idTo';
    } else {
      chatId = '$idFrom-$idTo';
    }
    chatRef.document(chatId).collection("chats").add({
      "username": currentUser.username,
      "content": chatController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser.photoUrl,
      "idFrom": idFrom,
      "idTo": idTo,
      "chatId": chatId,
      "type": "chat",
    });
    chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Chat"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildChat()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: chatController,
              decoration: InputDecoration(labelText: "Write a message..."),
            ),
            trailing: OutlinedButton(
              onPressed: addChat,
              child: Text("Send"),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chats extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String content;
  final Timestamp timestamp;
  final String chatId;

  _Chats({
    this.username,
    this.userId,
    this.avatarUrl,
    this.content,
    this.timestamp,
    this.chatId,
  });

  factory _Chats.fromDocument(DocumentSnapshot doc) {
    return _Chats(
      username: doc['username'],
      userId: doc['userId'],
      content: doc['content'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
      chatId: doc['chatId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(content),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}
