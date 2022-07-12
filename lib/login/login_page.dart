import 'package:cooking_social_network/enter/enter_information/enter_information.dart';
import 'package:cooking_social_network/login/bloc/login_bloc.dart';
import 'package:cooking_social_network/login/bloc/login_event.dart';
import 'package:cooking_social_network/login/bloc/login_state.dart';
import 'package:cooking_social_network/main/main_page.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:cooking_social_network/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
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
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 50,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Material(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                final regularExpression = RegExp(
                                    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
                                return regularExpression.hasMatch(text!)
                                    ? null
                                    : "Không đúng";
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Email",
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Material(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              controller: _passwodController,
                              obscureText: true,
                              validator: (text) {
                                return text!.length > 6
                                    ? null
                                    : "Password không đủ mạnh";
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<LoginBloc>(context).add(
                                      LoginWithEmailPasswordSubmitted(
                                          username: _emailController.text,
                                          password: _passwodController.text));
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
                              child: const Text("Login"),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Quên mật khẩu?",
                              style: TextStyle(color: Colors.tealAccent),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text("hoặc kết nối với"),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.google,
                                    size: 25,
                                  ),
                                  label: const Text("Google"),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueGrey),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(LoginWithGoogleSubmitted());
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.facebook,
                                    size: 25,
                                  ),
                                  label: const Text("Facebook"),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    UserRepository.logout();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Chưa có mật khẩu?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupPage()),
                                  );
                                },
                                child: const Text(
                                  "Đăng ký",
                                  style: TextStyle(color: Colors.tealAccent),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
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
}
