class Info {
  String name;
  int gender;
  String birthday;
  String description;
  String avatar;

  Info(
      {required this.name,
      required this.birthday,
      required this.gender,
      required this.description,
      required this.avatar});

  @override
  String toString() {
    return "$name $birthday $gender $description $avatar";
  }
}
