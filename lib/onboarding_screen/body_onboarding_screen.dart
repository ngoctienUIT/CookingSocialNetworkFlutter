import 'package:flutter/material.dart';

class BodyOnboardingScreen extends StatelessWidget {
  const BodyOnboardingScreen({Key? key, required this.data}) : super(key: key);

  final Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          "${data["title"]}",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
        ),
        Text("${data["text"]}"),
        const Spacer(
          flex: 2,
        ),
        Image.asset(
          "${data["image"]}",
          height: MediaQuery.of(context).size.height - 250,
        ),
      ],
    );
  }
}
