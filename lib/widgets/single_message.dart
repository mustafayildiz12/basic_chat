import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignleMessage extends StatelessWidget {
  final String message;
  final Timestamp date;
  final bool isMe;

  SignleMessage(
      {required this.message, required this.isMe, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(
            maxWidth: 200,
          ),
          decoration: BoxDecoration(
            color: isMe ? Colors.teal : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(message, style: const TextStyle(color: Colors.white)),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Text("${date.toDate().hour}:${date.toDate().minute}",
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 13)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
