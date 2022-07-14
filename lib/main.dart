import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cooking_social_network/main/main_page.dart';
// import 'package:cooking_social_network/login/login_page.dart';
import 'package:cooking_social_network/onboarding_screen/onboarding_page.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
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
      home: AnimatedSplashScreen(
        splash: Image.asset("assets/images/cooking.png"),
        nextScreen: UserRepository.isSignIn()
            ? const MainPage()
            : const OnboardingPage(),
        backgroundColor: Colors.red,
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: 350,
        duration: 3000,
      ),
      builder: EasyLoading.init(),
    );
  }
}
