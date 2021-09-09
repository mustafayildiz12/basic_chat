import 'package:basic_chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future signIn() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExist = await firebaseFirestore
        .collection("users")
        .doc(userCredential.user!.uid)
        .get();

    if (userExist.exists) {
      print("User already signed in");
    } else {
      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "email": userCredential.user!.email,
        "name": userCredential.user!.displayName,
        "image": userCredential.user!.photoURL,
        "uid": userCredential.user!.uid,
        "date": DateTime.now(),
      });
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://cdn.iconscout.com/icon/free/png-256/chat-2639493-2187526.png"))),
              ),
            ),
            const Text(
              "Flutter Chat",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  signIn();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://e7.pngegg.com/pngimages/114/607/png-clipart-g-suite-pearl-river-middle-school-google-software-suite-email-sign-up-button-text-logo.png",
                      height: 36,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Google ile Giriş Yap",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 12))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
