import 'package:cooking_social_network/model/method.dart';
import 'package:flutter/material.dart';

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final List<Method> methods = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Cách làm:",
              style: TextStyle(
                  fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          methods.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: methods.length,
                    itemBuilder: (context, index) => Text("data"),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                )
              : const SizedBox.shrink(),
          methods.isNotEmpty
              ? const SizedBox(height: 30)
              : const SizedBox.shrink(),
          Center(
            child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text("Thêm một bước")),
          )
        ],
      ),
    );
  }
}
