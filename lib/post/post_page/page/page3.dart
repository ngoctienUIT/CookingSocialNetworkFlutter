import 'dart:math';

import 'package:cooking_social_network/model/ingredient.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Ingredient> ingredients = [];
  final List<String> unitIngredients = [
    "Teaspoon",
    "Tablespoon",
    "Desertspoon",
    "Cup",
    "Ounce",
    "Fluid ounce",
    "Pound",
    "Pint",
    "Quart",
    "Gallon",
    "Gram",
    "Kilogam",
    "Liter"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ingredients = widget.post.ingredients;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.red),
            width: double.infinity,
            child: const Text(
              "Một công thức mới ư? Hãy bắt đầu nào",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Nguyên liệu:",
              style: TextStyle(
                  fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          ingredients.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = ingredients.removeAt(oldIndex);
                        ingredients.insert(newIndex, item);
                      });
                    },
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) => Dismissible(
                      background: const Card(
                        color: Color.fromRGBO(209, 26, 42, 1),
                        child: Center(
                          child: Text(
                            "Xóa",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          ingredients.removeAt(index);
                        });
                      },
                      key: Key(ingredients[index].hashCode.toString()),
                      child: itemIngredient(
                          key: ValueKey(index),
                          name: ingredients[index].name,
                          amount: ingredients[index].amount,
                          unit: ingredients[index].unit),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ingredients.isNotEmpty
              ? const SizedBox(height: 30)
              : const SizedBox.shrink(),
          Center(
            child: ElevatedButton.icon(
                onPressed: () {
                  showBottomSheet(context);
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text("Thêm nguyên liệu")),
          )
        ],
      ),
    );
  }

  Widget itemIngredient(
      {required String name,
      required int amount,
      required String unit,
      required Key key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("$amount", style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 5),
                Text(unit, style: const TextStyle(fontSize: 16))
              ],
            ),
          )
        ],
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    TextEditingController ingredientController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String unit = unitIngredients.first;

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 6,
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Thêm nguyên liệu",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Nguyên liệu:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextFormField(
                    controller: ingredientController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Số lượng:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            TextFormField(
                                controller: amountController,
                                keyboardType: TextInputType.number)
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Đơn vị:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            DropdownButtonFormField<String>(
                                menuMaxHeight: 200,
                                value: "Teaspoon",
                                items: unitIngredients
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (name) {
                                  unit = name!;
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          ingredients.add(Ingredient(
                              amount: int.parse(amountController.text),
                              name: ingredientController.text,
                              unit: unit));
                          widget.post.ingredients = ingredients;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Thêm"),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
