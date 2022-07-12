import 'package:cooking_social_network/enter/widget/enter_button.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:flutter/material.dart';

class EnterBirthday extends StatefulWidget {
  EnterBirthday({Key? key, required this.nextPage, required this.info})
      : super(key: key);
  Function(Info) nextPage;
  Info info;

  @override
  State<EnterBirthday> createState() => _EnterBirthdayState();
}

class _EnterBirthdayState extends State<EnterBirthday> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "Ngày sinh của bạn?",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Chúng tôi sẽ không bao giờ quên nó"),
          const SizedBox(
            height: 100,
          ),
          InkWell(
            onTap: (() async {
              DateTime newDate = await showDatePicker(
                  context: context,
                  initialDate: dateTime,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100)) as DateTime;
              if (newDate == null) return;
              setState(() {
                dateTime = newDate;
              });
            }),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(
                    "${dateTime.day < 10 ? "0${dateTime.day}" : dateTime.day}/${dateTime.month < 10 ? "0${dateTime.month}" : dateTime.month}/${dateTime.year}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          enterButton("Tiếp", () {
            widget.info.birthday =
                "${dateTime.day < 10 ? "0${dateTime.day}" : dateTime.day}/${dateTime.month < 10 ? "0${dateTime.month}" : dateTime.month}/${dateTime.year}";
            widget.nextPage(widget.info);
          })
        ],
      ),
    );
  }
}
