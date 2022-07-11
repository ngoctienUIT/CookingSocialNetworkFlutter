import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginUserNameChange extends LoginEvent {
  final String username;

  LoginUserNameChange({required this.username});

  @override
  List<Object?> get props => [username];
}

class LoginPasswordChange extends LoginEvent {
  final String password;

  LoginPasswordChange({required this.password});

  @override
  List<Object?> get props => [password];
}

class LoginWithEmailPasswordSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginWithEmailPasswordSubmitted(
      {required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LoginWithGoogleSubmitted extends LoginEvent {}
