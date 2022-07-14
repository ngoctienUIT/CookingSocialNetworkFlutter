class Comment {
  List<String> favourite;
  String content;
  String userName;
  DateTime time;

  Comment(
      {required this.favourite,
      required this.content,
      required this.userName,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      "favourite": favourite,
      "content": content,
      "userName": userName,
      "time": time
    };
  }
}
