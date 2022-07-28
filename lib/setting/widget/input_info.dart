import 'package:flutter/material.dart';

Widget inputInfo(
    {required String lable, required TextEditingController controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        lable,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(185, 189, 199, 1),
        ),
      ),
      const SizedBox(height: 5),
      TextFormField(
        maxLines: 1,
        controller: controller,
        style: const TextStyle(fontSize: 20, height: 1),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                width: 2, color: Color.fromRGBO(185, 189, 199, 1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                width: 2, color: Color.fromRGBO(185, 189, 199, 1)),
          ),
        ),
      ),
    ],
  );
}
