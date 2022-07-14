import 'package:cooking_social_network/model/ingredient.dart';
import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final List<Ingredient> ingredients = [];

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
                  setState(() {
                    ingredients
                        .add(Ingredient(amount: 0, name: "name", unit: "unit"));
                  });
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
}
