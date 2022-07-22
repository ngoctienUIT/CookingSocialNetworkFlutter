import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/repository/history_repository.dart';
import 'package:flutter/material.dart';

class SearchView extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
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
        close(context, "");
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
    close(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query == "" ? searchHistory() : userSearch();
  }

  Widget userSearch() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("info").snapshots(),
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
    return StreamBuilder<DocumentSnapshot>(
      stream: HistoryRepository.getDataHistory(),
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
}
