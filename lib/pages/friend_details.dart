import 'package:basic_chat/widgets/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FriendDetails extends StatefulWidget {
  final String friendId;
  final String friendName;
  final String friendImage;

  FriendDetails(
      {required this.friendId,
      required this.friendName,
      required this.friendImage});

  @override
  _FriendDetailsState createState() => _FriendDetailsState();
}

class _FriendDetailsState extends State<FriendDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text(
          widget.friendName,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.grey.shade300,
              child: CachedNetworkImage(
                imageUrl: widget.friendImage,
                placeholder: (context, url) =>
                spinkit,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 150,
              ),
            ),

          ),
          SizedBox(
            height: 30,
          ),
          Text(widget.friendName,style: const TextStyle(fontSize: 20),),
          SizedBox(
            height: 30,
          ),
          Text(widget.friendId,style: const TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}
