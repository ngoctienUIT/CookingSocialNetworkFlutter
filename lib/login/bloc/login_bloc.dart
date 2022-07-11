import 'package:cooking_social_network/login/bloc/login_event.dart';
import 'package:cooking_social_network/login/bloc/login_state.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    on<LoginUserNameChange>(
        (event, emit) => emit(state.copyWith(username: event.username)));

    on<LoginPasswordChange>(
        (event, emit) => emit(state.copyWith(username: event.password)));

    on<LoginWithEmailPasswordSubmitted>((event, emit) async {
      try {
        var result = await UserRepository.signInWithEmailPassword(
            email: event.username, password: event.password);
        if (result == UserState.success) {
          emit(LoginSuccess());
        } else {
          emit(LoginFaile(userState: result));
        }
      } catch (e) {
        emit(LoginFaile(userState: UserState.error));
      }
    });

    on<LoginWithGoogleSubmitted>((event, emit) async {
      try {
        await UserRepository.signInWithGoogle();
        emit(LoginSuccess());
      } catch (_) {
        emit(LoginFaile(userState: UserState.error));
      }
    });
  }
}
