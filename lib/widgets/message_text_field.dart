
import 'package:basic_chat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:async';

class MessageTextField extends StatefulWidget {
  final String userId;
  final UserModel currentUser;
  final String friendId;
  final String friendName;

  MessageTextField(this.userId, this.friendId, this.friendName,this.currentUser);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();

  final String oneSignalId = "6f1fa57d-6fdc-4547-bdfa-0623913a2464";
  String _debugLabelString = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalId);
    OneSignal.shared.promptUserForPushNotificationPermission();
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(false);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("OPENED NOTIFICATION");
      print(result.notification.jsonRepresentation().replaceAll("\\n", "\n"));
      this.setState(() {
        _debugLabelString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
            (OSEmailSubscriptionStateChanges changes) {
          print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
        });

    OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          SizedBox(
            width: size.width * 7.8 / 10,
            height: size.height / 15,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0),
                      gapPadding: 10,
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();

              if (message.isNotEmpty) {

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.userId)
                    .collection("messages")
                    .doc(widget.friendId)
                    .collection("chats")
                    .add({
                  "senderId": widget.userId,
                  "receiverId": widget.friendId,
                  "message": message,
                  "type": "text",
                  "date": DateTime.now()
                }).then((value) => {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.userId)
                              .collection("messages")
                              .doc(widget.friendId)
                              .set({
                            "last_msg": message,
                          })
                        });

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.friendId)
                    .collection("messages")
                    .doc(widget.userId)
                    .collection("chats")
                    .add({
                  "senderId": widget.userId,
                  "receiverId": widget.friendId,
                  "message": message,
                  "type": "text",
                  "date": DateTime.now()
                }).then((value) => {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.friendId)
                              .collection("messages")
                              .doc(widget.userId)
                              .set({
                            "last_msg": message,
                          })
                        });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
