class Method {
  String image;
  String title;
  String content;

  Method({required this.image, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return {"image": image, "title": title, "content": content};
  }
}
