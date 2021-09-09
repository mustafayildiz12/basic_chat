import 'package:basic_chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  UserModel user;

  SearchScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Kullanıcı Bulunamadı")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['email'] != widget.user.email) {
          searchResult.add(user.data());
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arama Yap"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        hintText: "Arkadaş ara",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  onSearch();
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          if (searchResult.isNotEmpty)
            ListView.builder(
                itemCount: searchResult.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.network(searchResult[index]["image"]),
                    ),
                    title: Text(searchResult[index]["name"]),
                    subtitle: Text(searchResult[index]["email"]),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          searchController.text = "";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  currentUser: widget.user,
                                  friendId: searchResult[index]["uid"],
                                  friendImage: searchResult[index]["image"],
                                  friendName: searchResult[index]["name"],
                                )));
                      },
                      icon: const Icon(Icons.message),
                    ),
                  );
                })
          else if (isLoading == true)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
