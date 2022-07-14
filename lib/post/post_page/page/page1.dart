import 'dart:io';
import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Page1 extends StatefulWidget {
  Page1({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final List<String> images = [];
  final TextEditingController _namecontroller = TextEditingController();

  int currentPage = 0;

  Future pickImage() async {
    try {
      final imageList = await ImagePicker().pickMultiImage();
      if (imageList == null) return;
      setState(() {
        images.addAll(imageList.map((image) => image.path).toList());
        widget.post.images = images;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Tên món ăn",
                style: textStyle(),
              ),
              TextFormField(
                controller: _namecontroller,
                onChanged: (text) {
                  widget.post.nameFood = text;
                },
                decoration: const InputDecoration(hintText: "Gà rán"),
              ),
              const SizedBox(height: 30),
              Text(
                "Hình ảnh món ăn",
                style: textStyle(),
              ),
              const SizedBox(height: 20),
              images.isNotEmpty
                  ? SizedBox(
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PageView.builder(
                            onPageChanged: (value) {
                              setState(() {
                                currentPage = value;
                              });
                            },
                            itemCount: images.length,
                            itemBuilder: (context, index) => Image.file(
                              File(images[index]),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Row(
                              children: List.generate(images.length,
                                  (index) => buildDot(index: index)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                    onPressed: () {
                      pickImage();
                    },
                    icon: const Icon(FontAwesomeIcons.image),
                    label: const Text("Thêm hình ảnh")),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return const TextStyle(
        fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold);
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 6,
      width: currentPage == index ? 20 : 6,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
