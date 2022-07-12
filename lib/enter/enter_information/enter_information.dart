import 'package:cooking_social_network/enter/enter_information/page/avatar_picker.dart';
import 'package:cooking_social_network/enter/enter_information/page/enter_birthday.dart';
import 'package:cooking_social_network/enter/enter_information/page/enter_description.dart';
import 'package:cooking_social_network/enter/enter_information/page/enter_gender.dart';
import 'package:cooking_social_network/enter/enter_information/page/enter_name.dart';
import 'package:cooking_social_network/main/main_page.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EnterInformation extends StatefulWidget {
  const EnterInformation({Key? key}) : super(key: key);

  @override
  State<EnterInformation> createState() => _EnterInformationState();
}

class _EnterInformationState extends State<EnterInformation> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Info info =
      Info(name: "", birthday: "", gender: 0, description: "", avatar: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            if (_currentPage == 0) {
              await UserRepository.logout();
              if (!mounted) return;
              Navigator.of(context).pop();
            } else {
              setState(() {
                _currentPage--;
                _pageController.animateToPage(_currentPage,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              });
            }
          },
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Step ${_currentPage + 1} of 5",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          EnterName(
            nextPage: nextPage,
            info: info,
          ),
          EnterBirthday(
            nextPage: nextPage,
            info: info,
          ),
          EnterGender(
            nextPage: nextPage,
            info: info,
          ),
          EnterDescription(
            nextPage: nextPage,
            info: info,
          ),
          AvatarPicker(
            nextPage: nextPage,
            info: info,
          )
        ],
      )),
    );
  }

  void nextPage(Info newData) async {
    info = newData;
    if (_currentPage < 4) {
      setState(() {
        _currentPage++;
        _pageController.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      });
    } else {
      EasyLoading.show();
      await UserRepository.initData(info);
      EasyLoading.dismiss();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }
}
