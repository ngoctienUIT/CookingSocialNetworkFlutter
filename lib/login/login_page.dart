import 'package:cooking_social_network/enter/enter_information/enter_information.dart';
import 'package:cooking_social_network/generated/l10n.dart';
import 'package:cooking_social_network/login/bloc/login_bloc.dart';
import 'package:cooking_social_network/login/bloc/login_event.dart';
import 'package:cooking_social_network/login/bloc/login_state.dart';
import 'package:cooking_social_network/login/widget/login_button.dart';
import 'package:cooking_social_network/login/widget/show_error.dart';
import 'package:cooking_social_network/main/main_page.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:cooking_social_network/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwodController = TextEditingController();
  bool checkEmail = true;
  bool checkPassword = true;

  @override
  void initState() {
    super.initState();
    // _emailController.addListener(() {
    //   BlocProvider.of<LoginBloc>(context)
    //       .add(LoginUserNameChange(username: _emailController.text));
    // });

    // _passwodController.addListener(() {
    //   BlocProvider.of<LoginBloc>(context)
    //       .add(LoginPasswordChange(password: _passwodController.text));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginSuccess) {
            SchedulerBinding.instance.addPostFrameCallback((_) async {
              final check = await UserRepository.checkInfo();
              if (!mounted) return;
              if (check) {
                EasyLoading.dismiss();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EnterInformation()),
                );
              }
            });
          } else if (state is LoginFaile) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              String text = '';
              if (state.userState == UserState.error) {
                text = "Đăng nhập thất bại";
              } else if (state.userState == UserState.userNotFound) {
                text = "Người dùng không tồn tại";
              } else if (state.userState == UserState.wrongPassword) {
                text = "Mật khẩu không chính xác";
              }
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(text)));
            });
          }
          return Scaffold(
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/background_login.jpg"),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            child: Text(
                              S.current.login,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                          const SizedBox(height: 50),
                          loginInput(
                              hintText: "Email",
                              action: (text) {
                                final regularExpression = RegExp(
                                    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
                                setState(() {
                                  checkEmail = regularExpression.hasMatch(text)
                                      ? true
                                      : false;
                                });
                              },
                              controller: _emailController,
                              show: true),
                          showError(checkEmail, "Không đúng"),
                          const SizedBox(height: 20),
                          loginInput(
                              hintText: "Password",
                              action: (text) {
                                checkPassword = text.length > 6 ? true : false;
                              },
                              controller: _passwodController,
                              show: false),
                          showError(checkPassword, "Password không đủ mạnh"),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (checkEmail && checkPassword) {
                                    EasyLoading.show();
                                    BlocProvider.of<LoginBloc>(context).add(
                                      LoginWithEmailPasswordSubmitted(
                                          username: _emailController.text,
                                          password: _passwodController.text),
                                    );
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              child: Text(S.current.login),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              S.current.forgotPassword,
                              style: const TextStyle(color: Colors.tealAccent),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Text(S.current.orConnectWith),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loginButton(
                                  icon: FontAwesomeIcons.google,
                                  color: Colors.blueGrey,
                                  text: "Google",
                                  action: () {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(LoginWithGoogleSubmitted());
                                  }),
                              const SizedBox(width: 20),
                              loginButton(
                                  icon: FontAwesomeIcons.facebook,
                                  color: Colors.blue,
                                  text: "Facebook",
                                  action: () {}),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(S.current.noPasswordYet),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupPage()),
                                  );
                                },
                                child: Text(
                                  S.current.signUp,
                                  style:
                                      const TextStyle(color: Colors.tealAccent),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget loginInput(
      {required String hintText,
      required Function(String) action,
      required TextEditingController controller,
      required bool show}) {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        controller: controller,
        obscureText: !show,
        validator: (text) {
          setState(() {
            action(text!);
          });
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
        ),
      ),
    );
  }
}
