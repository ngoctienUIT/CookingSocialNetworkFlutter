import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:cooking_social_network/setting/widget/input_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  File? image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  Info? info;

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
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: info == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("info")
                  .doc(FirebaseAuth.instance.currentUser!.email.toString())
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Không có gì ở đây"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                info = Info.getDataFromSnapshot(snapshot: snapshot.requireData);
                if (_nameController.text == "") {
                  _nameController.text = info!.name;
                  _descriptionController.text = info!.description;
                  _birthdayController.text = info!.birthday;
                }
                return bodySettingProfile(info!);
              })
          : bodySettingProfile(info!),
    );
  }

  Widget bodySettingProfile(Info info) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                pickImage();
              },
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: image != null
                          ? Image.file(
                              image!,
                              width: 150,
                              height: 150,
                            )
                          : Image.network(
                              info.avatar,
                              width: 150,
                              height: 150,
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
            ),
            const SizedBox(height: 20),
            Text(
              info.username,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(151, 157, 170, 1),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  inputInfo(
                    lable: "Tên",
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  inputBirthday(),
                  const SizedBox(height: 20),
                  inputGender(),
                  const SizedBox(height: 20),
                  inputInfo(
                    lable: "Mô tả",
                    controller: _descriptionController,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () async {
                        if (image != null) {
                          info.avatar = await PostRepository.uploadImage(
                            image!.path,
                            "avatar",
                            FirebaseAuth.instance.currentUser!.email.toString(),
                          );
                        }
                        info.birthday = _birthdayController.text;
                        info.description = _descriptionController.text;
                        info.name = _nameController.text;
                        UserRepository.updateInfo(info: info);
                      },
                      child: const Text(
                        "Lưu",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget inputGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Giới tính",
          style: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(185, 189, 199, 1),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            customCheckBox(text: "Nam", index: 0),
            const SizedBox(width: 10),
            customCheckBox(text: "Nữ", index: 1),
          ],
        ),
      ],
    );
  }

  Expanded customCheckBox({required String text, required int index}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: const Color.fromRGBO(185, 189, 199, 1),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Transform.scale(
          scale: 1.2,
          child: RadioListTile<int>(
            title: Text(text),
            value: index,
            groupValue: info!.gender,
            onChanged: (value) {
              setState(() {
                info!.gender = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget inputBirthday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ngày sinh",
          style: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(185, 189, 199, 1),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          onTap: () async {
            DateTime now = DateTime(
                int.parse(_birthdayController.text.substring(6, 10)),
                int.parse(_birthdayController.text.substring(3, 5)),
                int.parse(_birthdayController.text.substring(0, 2)));
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: now,
                firstDate: DateTime(1950),
                lastDate: DateTime.now());

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(pickedDate);
              setState(() {
                _birthdayController.text = formattedDate;
              });
            }
          },
          readOnly: true,
          maxLines: 1,
          controller: _birthdayController,
          style: const TextStyle(fontSize: 20, height: 1),
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
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
}
