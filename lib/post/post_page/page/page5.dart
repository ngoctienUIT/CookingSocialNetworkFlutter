import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';

class Page5 extends StatelessWidget {
  Page5({Key? key, required this.post}) : super(key: key);
  final Post post;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _descriptionController.text = post.description;
    return Column(
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Đôi lời muốn nói",
            style: TextStyle(
                fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: _descriptionController,
            onChanged: (description) {
              post.description = description;
            },
          ),
        )
      ],
    );
  }
}
