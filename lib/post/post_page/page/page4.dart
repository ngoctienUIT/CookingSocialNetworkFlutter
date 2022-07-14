import 'dart:io';

import 'package:cooking_social_network/model/method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
                onPressed: () {
                  showBottomSheet(context);
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text("Thêm một bước")),
          )
        ],
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    File? image;

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(20),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Thêm nguyên liệu",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Mô tả bước làm:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextFormField(),
                      const SizedBox(height: 20),
                      const Text(
                        "Ảnh:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      image == null
                          ? const SizedBox.shrink()
                          : Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Image.file(image!),
                              ),
                            ),
                      Center(
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                final imageFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (imageFile == null) return;
                                setState(() {
                                  image = File(imageFile.path);
                                });
                              } on PlatformException catch (e) {
                                print(e);
                              }
                            },
                            icon: const Icon(FontAwesomeIcons.image),
                            label: const Text("Thêm hình ảnh")),
                      ),
                      const SizedBox(height: 20),
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
              ),
            );
          });
        });
  }
}
