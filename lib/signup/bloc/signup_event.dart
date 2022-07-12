part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupWithEmailPasswordSubmitted extends SignupEvent {
  final String username;
  final String password;

  const SignupWithEmailPasswordSubmitted(
      {required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class SignupInitialEvent extends SignupEvent {}
