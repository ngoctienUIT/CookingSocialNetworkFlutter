import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupWithEmailPasswordSubmitted>((event, emit) async {
      try {
        var result = await UserRepository.createUserWithEmailAndPassword(
            email: event.username, password: event.password);
        if (result == UserState.success) {
          UserRepository.initData();
          emit(SignupSuccess());
        } else {
          emit(SignupFaile());
        }
      } catch (_) {
        emit(SignupFaile());
      }
    });
    on<SignupInitialEvent>((event, emit) => emit(SignupInitial()));
  }
}
