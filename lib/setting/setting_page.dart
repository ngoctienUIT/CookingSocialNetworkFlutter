import 'package:cooking_social_network/login/login_page.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:cooking_social_network/setting/page/profile_setting.dart';
import 'package:cooking_social_network/setting/widget/item_setting.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Cài đặt",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          itemSetting(
            text: "Tài khoản",
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSetting(),
                ),
              );
            },
            icon: Icons.account_circle,
          ),
          itemSetting(
            text: "Ngôn ngữ",
            action: () {},
            icon: Icons.translate,
          ),
          itemSetting(
            text: "Báo cảo",
            action: () {},
            icon: Icons.send,
          ),
          itemSetting(
            text: "Thông tin",
            action: () {},
            icon: Icons.info_outline_rounded,
          ),
          buttonLogout(context)
        ],
      ),
    );
  }

  Widget buttonLogout(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.75,
      child: ElevatedButton(
        onPressed: () async {
          await UserRepository.logout();
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        child: const Text(
          "Đăng xuất",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
