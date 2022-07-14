import 'package:cooking_social_network/login/login_page.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 0.5,
          child: Container(
            decoration: const BoxDecoration(),
            height: 55,
            width: double.infinity,
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    "Trần Ngọc Tiến",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: TextButton(
                    onPressed: () async {
                      await UserRepository.logout();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false);
                    },
                    child: const Icon(Icons.menu, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: Text("abc"))
      ],
    );
  }
}
