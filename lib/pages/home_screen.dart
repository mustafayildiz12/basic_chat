import 'package:basic_chat/models/user_model.dart';
import 'package:basic_chat/pages/auth_screen.dart';
import 'package:basic_chat/pages/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'chat_screen.dart';


class HomeScreen extends StatefulWidget {
  UserModel user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text("SOHBETLER"),
        actions: [
          IconButton(
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) => false);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('messages').snapshots(),
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(snapshot.data.docs.length < 1){
                return const Center(
                  child: Text("Henüz Hiç Mesajınız yok"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    var friendId = snapshot.data.docs[index].id;
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                      builder: (context,AsyncSnapshot asyncSnapshot){
                        if(asyncSnapshot.hasData){
                          var friend = asyncSnapshot.data;
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: CachedNetworkImage(
                                imageUrl: friend['image'],
                                placeholder: (context,url)=>const CircularProgressIndicator(),
                                errorWidget: (context,url,error)=>const Icon(Icons.error),
                                height: 50,
                              ),
                            ),
                            title: Text(friend['name']),
                            subtitle: Text("$lastMsg",style: const TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
                                  currentUser: widget.user,
                                  friendId: friend['uid'],
                                  friendName: friend['name'],
                                  friendImage: friend['image'])));
                            },
                          );
                        }
                        return const LinearProgressIndicator();
                      },

                    );
                  });
            }
            return const Center(child:  CircularProgressIndicator(),);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchScreen(
                        user: widget.user,
                      )));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
