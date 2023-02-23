import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cardpalz/pages/home.dart';
import 'package:cardpalz/widgets/header.dart';
import 'package:cardpalz/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cardpalz/models/user.dart';


final usersRef = Firestore.instance.collection('users');
final chatRef = Firestore.instance.collection('chat');


class Chat extends StatefulWidget {
  final String chatId;
  final String idFrom;
  final String idTo;
  final String content;

  Chat({
    this.chatId,
    this.idFrom,
    this.idTo,
    this.content,    
    });

  @override
  _ChatState createState() => _ChatState(
        chatId: this.chatId,
        idFrom: this.idFrom,
        idTo: this.idTo,
        content: this.content,
      );
}

class _ChatState extends State<Chat> {
  TextEditingController chatController = TextEditingController();
  final String chatId;
  final String idFrom;
  final String idTo;
  final String content;

  _ChatState({
    this.chatId,
    this.idFrom,
    this.idTo,
    this.content
  });


  buildChat() {
    return StreamBuilder(
        stream: chatRef
            .document(chatId)
            .collection('chat')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<_Chat> chats = [];
          snapshot.data.documents.forEach((doc) {
            chats.add(_Chat.fromDocument(doc));
          });
          return ListView(
            children: chats,
          );
        });
  }

  addChat() {
    chatRef.document(chatId).collection("messages").add({
      "username": currentUser.username,
      "content": chatController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser.photoUrl,
      "userId": currentUser.id,
      "messagesId": chatId,
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

class _Chat extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String content;
  final Timestamp timestamp;
  final Timestamp messagesId;

  _Chat({
    this.username,
    this.userId,
    this.avatarUrl,
    this.content,
    this.timestamp,
    this.messagesId,
  });

  factory _Chat.fromDocument(DocumentSnapshot doc) {
    return _Chat(
      username: doc['username'],
      userId: doc['userId'],
      content: doc['content'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
      messagesId: doc['messagesId'],
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
