import 'package:basic_chat/models/user_model.dart';
import 'package:basic_chat/widgets/message_text_field.dart';
import 'package:basic_chat/widgets/single_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  ChatScreen({required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              friendName,
              style: const TextStyle(fontSize: 20),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl: friendImage,
                placeholder: (context,url)=>const CircularProgressIndicator(),
                errorWidget: (context,url,error)=>const Icon(Icons.error),
                height: 50,
              ),
            ),

          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(
                    currentUser.uid).collection('messages').doc(friendId)
                    .collection('chats').orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text("Say Hi"),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        bool isMe = snapshot.data.docs[index]['senderId'] ==
                            currentUser.uid;

                        return SignleMessage(message: snapshot.data
                            .docs[index]['message'], isMe: isMe);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: MessageTextField(currentUser.uid, friendId),
          ),
        ],
      ),
    );
  }
}
