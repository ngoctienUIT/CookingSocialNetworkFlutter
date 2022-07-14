import 'package:cooking_social_network/model/ingredient.dart';
import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final List<Ingredient> ingredients = [];
  final List<String> itemIngredients = [
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  child: ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) => itemIngredient(),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                  // setState(() {
                  //   ingredients
                  //       .add(Ingredient(amount: 0, name: "name", unit: "unit"));
                  // });
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text("Thêm nguyên liệu")),
          )
        ],
      ),
    );
  }

  Row itemIngredient() {
    return Row(
      children: const [
        Expanded(child: TextField()),
        SizedBox(width: 20),
        SizedBox(width: 50, child: TextField()),
        SizedBox(width: 20),
        SizedBox(width: 50, child: TextField())
      ],
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Thêm nguyên liệu",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Nguyên liệu:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextFormField(),
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
                            TextFormField(keyboardType: TextInputType.number)
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
                                items: itemIngredients
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (name) {})
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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
