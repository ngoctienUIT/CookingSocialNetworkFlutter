class Method {
  String image;
  String title;
  String content;

  Method({required this.image, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return {"image": image, "title": title, "content": content};
  }

  factory Method.getDataFromMap({required Map<String, dynamic> data}) {
    return Method(
        image: data["image"], title: data["title"], content: data["content"]);
  }
}
