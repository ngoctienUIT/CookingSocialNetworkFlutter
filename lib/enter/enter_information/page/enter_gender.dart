import 'package:cooking_social_network/enter/widget/enter_button.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:flutter/material.dart';

class EnterGender extends StatefulWidget {
  const EnterGender({Key? key, required this.nextPage, required this.info})
      : super(key: key);
  final Function(Info) nextPage;
  final Info info;

  @override
  State<EnterGender> createState() => _EnterGenderState();
}

class _EnterGenderState extends State<EnterGender> {
  int _gender = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "Giới tính của bạn là gì?",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 10),
          const Text("Tôi có thể gọi bạn là gì?"),
          const SizedBox(height: 100),
          Center(
            child: SizedBox(
              width: 200,
              child: Column(
                children: [
                  genderButton(value: 0, text: "Nam"),
                  genderButton(value: 1, text: "Nữ"),
                ],
              ),
            ),
          ),
          enterButton("Tiếp", () {
            widget.info.gender = _gender;
            widget.nextPage(widget.info);
          })
        ],
      ),
    );
  }

  RadioListTile<int> genderButton({required int value, required String text}) {
    return RadioListTile(
        title: Text(text),
        value: value,
        groupValue: _gender,
        onChanged: (value) {
          setState(() {
            _gender = int.parse(value.toString());
          });
        });
  }
}
