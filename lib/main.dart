import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cooking_social_network/main/main_page.dart';
// import 'package:cooking_social_network/login/login_page.dart';
import 'package:cooking_social_network/onboarding_screen/onboarding_page.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // UserRepository.createUserWithEmailAndPassword(
  //     email: "ngoctien@gmail.com", password: "password123");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          // const LoginPage()
          AnimatedSplashScreen(
        splash: Image.asset("assets/images/cooking.png"),
        nextScreen: UserRepository.isSignIn()
            ? const MainPage()
            : const OnboardingPage(),
        backgroundColor: Colors.red,
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: 350,
        duration: 3000,
      ),
    );
  }
}
