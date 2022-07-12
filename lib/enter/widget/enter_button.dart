import 'package:flutter/material.dart';

Padding enterButton(String text, Function action) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () {
          action();
        },
        child: Text(text),
      ),
    ),
  );
}
