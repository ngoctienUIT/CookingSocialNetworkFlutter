class Method {
  String image;
  String content;

  Method({required this.image, required this.content});

  Map<String, dynamic> toMap() {
    return {"image": image, "content": content};
  }
}
