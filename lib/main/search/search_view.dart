import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/repository/history_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchView extends SearchDelegate<String> {
  String search;
  bool count = true;
  SearchView({required this.search}) {
    query = search;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      query == ""
          ? const SizedBox.shrink()
          : IconButton(
              onPressed: () {
                query = "";
              },
              icon: const Icon(Icons.clear_rounded),
            )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, query);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void showResults(BuildContext context) {
    if (query != "") HistoryRepository.updateHistory(search: query);
    close(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (count) {
      query = search;
      count = false;
    }
    return query == "" ? searchHistory() : userSearch();
  }

  Widget userSearch() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("info").get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Không có gì ở đây"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Info> listUser = snapshot.data!.docs
            .map(
              (doc) => Info.getDataFromSnapshot(snapshot: doc),
            )
            .toList()
            .where((user) =>
                user.username.toLowerCase().contains(query.toLowerCase()) ||
                user.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return ListView.builder(
          itemCount: listUser.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: InkWell(
              onTap: () {
                query = listUser[index].name;
                close(context, query);
              },
              child: Row(
                children: [
                  ClipOval(
                      child: Image.network(listUser[index].avatar, width: 35)),
                  const SizedBox(width: 10),
                  Text(
                    listUser[index].name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      query = listUser[index].name;
                    },
                    icon: const Icon(Icons.call_made_rounded),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget searchHistory() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("history")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Không có gì ở đây"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        var data = snapshot.requireData.data() as Map<String, dynamic>;
        List<String> listHistory = (data["history"] as List<dynamic>)
            .map((history) => history.toString())
            .toList()
            .where((history) =>
                history.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: listHistory.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: InkWell(
              onTap: () {
                query = listHistory[index];
                close(context, query);
              },
              child: Row(
                children: [
                  Text(
                    listHistory[index],
                    style: const TextStyle(fontSize: 17),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      query = listHistory[index];
                    },
                    icon: const Icon(Icons.call_made_rounded),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.normal);
}
