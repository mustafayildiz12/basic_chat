import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String image;
  String uid;
  Timestamp date;

  UserModel(
      {required this.name,
      required this.email,
      required this.image,
      required this.uid,
      required this.date});

  factory UserModel.fromJson(DocumentSnapshot snapshot){
    return UserModel(
        name: snapshot["name"],
        email: snapshot["email"],
        image: snapshot["image"],
        uid: snapshot["uid"],
        date: snapshot["date"]);
  }
}
