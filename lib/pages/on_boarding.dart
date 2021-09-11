import 'package:basic_chat/pages/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({Key? key,required this.title,}) : super(key: key);

  final String title;

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          _globalKey.currentState?.showSnackBar(SnackBar(
            content: Text("Geç"),
          ));
        },
        finishCallback: () {
          _globalKey.currentState?.showSnackBar(SnackBar(
            content: Text("Başla"),
          ));
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthScreen()));
        },
      ),
    );
  }

  final pages = [
    PageModel(
        color: const Color(0xFF9B90BC),
        imageAssetPath: 'assets/chat1.png',
        title: '',
        body: '',
        doAnimateImage: true),
    PageModel.withChild(
        child: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Image.asset('assets/chat2.png', width: 300.0, height: 300.0),
        ),
        color: const Color(0xFF5886d6),
        doAnimateChild: true)
  ];
}