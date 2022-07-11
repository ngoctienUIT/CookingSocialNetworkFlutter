import 'package:cooking_social_network/repository/user_repository.dart';

class LoginState {
  final String username;
  final String password;

  const LoginState({this.username = '', this.password = ''});

  LoginState copyWith({
    String username = '',
    String password = '',
  }) {
    return LoginState(
        username: username != '' ? username : this.username,
        password: password != '' ? password : this.username);
  }
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginSuccess extends LoginState {}

class LoginFaile extends LoginState {
  final UserState userState;

  LoginFaile({required this.userState});
}
