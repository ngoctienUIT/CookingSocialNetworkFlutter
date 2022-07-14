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
  String cookingTime;
  String nameFood;
  String owner;
  String servers;
  double level;
  int share;

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
      required this.share});

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
      "level": "level",
      "share": share
    };
  }
}
