import 'dart:io';

import 'package:cooking_social_network/enter/widget/enter_button.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  const AvatarPicker({Key? key, required this.nextPage, required this.info})
      : super(key: key);
  final Function(Info) nextPage;
  final Info info;

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final cropImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square]);
      if (cropImage == null) return;
      setState(() {
        this.image = File(cropImage.path);
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "Chọn ảnh đại diện của bạn?",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 10),
          const Text("Tôi có thể gọi bạn là gì?"),
          const SizedBox(height: 50),
          InkWell(
            onTap: () {
              pickImage();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: image != null
                      ? Image.file(
                          image!,
                          width: 200,
                          height: 200,
                        )
                      : Image.asset(
                          "assets/images/cooking.png",
                          width: 200,
                          height: 200,
                        ),
                ),
                Image.asset(
                  "assets/images/add_photo.png",
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          enterButton("Hoàn thành", () {
            if (image != null) {
              widget.info.avatar = image!.path;
            }
            widget.nextPage(widget.info);
          })
        ],
      ),
    );
  }
}
