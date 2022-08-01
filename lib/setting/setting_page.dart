import 'package:cooking_social_network/generated/l10n.dart';
import 'package:cooking_social_network/login/login_page.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:cooking_social_network/setting/cubit/language_cubit.dart';
import 'package:cooking_social_network/setting/page/profile_setting.dart';
import 'package:cooking_social_network/setting/widget/item_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int language = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          S.current.setting,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          itemSetting(
            text: S.current.account,
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
            text: S.current.language,
            action: () {
              chooseLanguage();
            },
            icon: Icons.translate,
          ),
          itemSetting(
            text: S.current.report,
            action: () {},
            icon: Icons.send,
          ),
          itemSetting(
            text: S.current.info,
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
      height: 50,
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
        child: Text(
          S.current.logOut,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void chooseLanguage() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return BlocBuilder<LanguageCubit, Locale?>(
          builder: (context, state) {
            if (state == const Locale("vi", "")) {
              language = 0;
            } else {
              language = 1;
            }
            return SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RadioListTile<int>(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Text("Tiếng Việt"),
                          const Spacer(),
                          Image.asset("assets/images/vietnam.png", width: 50)
                        ],
                      ),
                    ),
                    value: 0,
                    groupValue: language,
                    onChanged: (value) {
                      setState(() {
                        context
                            .read<LanguageCubit>()
                            .change(const Locale("vi", ""));
                        language = value!;
                        Navigator.pop(context);
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Text("Tiếng Anh"),
                          const Spacer(),
                          Image.asset("assets/images/UK.png", width: 50)
                        ],
                      ),
                    ),
                    value: 1,
                    groupValue: language,
                    onChanged: (value) {
                      setState(() {
                        context
                            .read<LanguageCubit>()
                            .change(const Locale("en", ""));
                        language = value!;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
