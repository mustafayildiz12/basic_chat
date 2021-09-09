import 'package:flutter/material.dart';

class SignleMessage extends StatelessWidget {
  final String message;
  final bool isMe;

  SignleMessage({required this.message, required this.isMe});

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
            color: isMe ? Colors.black : Colors.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}