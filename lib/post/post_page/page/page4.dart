import 'dart:io';
import 'package:cooking_social_network/model/method.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Page4 extends StatefulWidget {
  const Page4({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  List<Method> methods = [];
  File? image;

  @override
  Widget build(BuildContext context) {
    methods = widget.post.methods;
    return SingleChildScrollView(
      child: Column(
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
                  child: ReorderableListView.builder(
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = methods.removeAt(oldIndex);
                        methods.insert(newIndex, item);
                      });
                    },
                    itemCount: methods.length,
                    itemBuilder: (context, index) => Dismissible(
                      background: const Card(
                        color: Color.fromRGBO(209, 26, 42, 1),
                        child: Center(
                          child: Text(
                            "Xóa",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          methods.removeAt(index);
                        });
                      },
                      key: Key(methods[index].hashCode.toString()),
                      child: methodItem(
                          index: index + 1,
                          method: methods[index],
                          key: ValueKey(index)),
                    ),
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

  Widget methodItem(
      {required int index, required Method method, required Key key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                borderRadius: const BorderRadius.all(Radius.circular(90)),
                elevation: 5,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(90))),
                  child: Center(
                    child: Text(
                      "$index",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  method.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method.content),
                const SizedBox(height: 10),
                Material(
                  elevation: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        File(method.image),
                        width: 100,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void showBottomSheet(BuildContext context) async {
    File? image;
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Form(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 6,
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    const Text(
                      "Thêm cách làm",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Tên bước làm:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextFormField(controller: titleController),
                              const SizedBox(height: 20),
                              const Text(
                                "Mô tả bước làm:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextFormField(controller: contentController),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Image.file(image!),
                                      ),
                                    ),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      final imageFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (imageFile == null) return;
                                      this.image = image;
                                      setState(() {
                                        image = File(imageFile.path);
                                      });
                                    } on PlatformException catch (e) {
                                      print(e);
                                    }
                                  },
                                  icon: const Icon(FontAwesomeIcons.image),
                                  label: Text(image == null
                                      ? "Thêm hình ảnh"
                                      : "Đổi ảnh"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    this.setState(() {
                                      methods.add(Method(
                                          image: image!.path,
                                          title: titleController.text,
                                          content: contentController.text));
                                      widget.post.methods = methods;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Thêm"),
                                ),
                              ),
                              const SizedBox(height: 10)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
