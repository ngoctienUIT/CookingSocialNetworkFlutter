import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/comment.dart';
import 'package:cooking_social_network/model/ingredient.dart';
import 'package:cooking_social_network/model/method.dart';

class Post {
  List<String> favourites;
  List<String> images;
  List<Comment> comments;
  List<Ingredient> ingredients;
  List<Method> methods;
  String description;
  String nameFood;
  String owner;
  String servers;
  double level;
  int share;
  int cookingTime;
  DateTime time;

  Post(
      {required this.comments,
      required this.favourites,
      required this.images,
      required this.ingredients,
      required this.methods,
      required this.description,
      required this.cookingTime,
      required this.nameFood,
      required this.level,
      required this.owner,
      required this.servers,
      required this.share,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      "favourites": favourites,
      "images": images,
      "comments": comments.map((comment) => comment.toMap()).toList(),
      "ingredients":
          ingredients.map((ingredient) => ingredient.toMap()).toList(),
      "methods": methods.map((method) => method.toMap()).toList(),
      "description": description,
      "cookingTime": cookingTime,
      "nameFood": nameFood,
      "owner": owner,
      "servers": servers,
      "level": level,
      "share": share,
      "time": DateTime.now()
    };
  }

  factory Post.getDataFromSnapshot({required DocumentSnapshot snapshot}) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Post(
        comments: (data["comments"] as List<dynamic>)
            .map((comment) => Comment.getDataFromMap(data: comment))
            .toList(),
        favourites: (data["favourites"] as List<dynamic>)
            .map((favourite) => favourite.toString())
            .toList(),
        images: (data["images"] as List<dynamic>)
            .map((image) => image.toString())
            .toList(),
        ingredients: (data["ingredients"] as List<dynamic>)
            .map((ingredient) => Ingredient.getDataFromMap(data: ingredient))
            .toList(),
        methods: (data["methods"] as List<dynamic>)
            .map((method) => Method.getDataFromMap(data: method))
            .toList(),
        description: data["description"],
        cookingTime: data["cookingTime"],
        nameFood: data["nameFood"],
        level: double.parse(data["level"].toString()),
        owner: data["owner"],
        servers: data["servers"],
        share: data["share"],
        time: (data["time"] as Timestamp).toDate());
  }
}
