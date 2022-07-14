class Ingredient {
  int amount;
  String name;
  String unit;

  Ingredient({required this.amount, required this.name, required this.unit});

  Map<String, dynamic> toMap() {
    return {"amount": amount, "name": name, "unit": unit};
  }
}
