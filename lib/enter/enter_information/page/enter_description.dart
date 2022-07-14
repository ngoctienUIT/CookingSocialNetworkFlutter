import 'package:cooking_social_network/enter/widget/enter_button.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:flutter/material.dart';

class EnterDescription extends StatelessWidget {
  EnterDescription({Key? key, required this.nextPage, required this.info})
      : super(key: key);
  final Function(Info) nextPage;
  final Info info;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Tên của bạn là gì?",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            const Text("Tôi có thể gọi bạn là gì?"),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Mô tả",
                ),
              ),
            ),
            enterButton("Tiếp", () {
              info.description = _descriptionController.text;
              nextPage(info);
            })
          ],
        ),
      ),
    );
  }
}
