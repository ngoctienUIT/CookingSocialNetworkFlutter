import 'dart:async';
import 'package:cooking_social_network/model/info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final Stream<Info> info;
  StreamSubscription? _infoSubscription;

  UserDataBloc({required this.info}) : super(UserDataInitial()) {
    // _loadData();

    on<UserDataFetchedEvent>((event, emit) async {
      _loadData();

      // emit(UserDataLoading());
      // var user = UserRepository.getInfoUser(
      // username: FirebaseAuth.instance.currentUser!.email.toString());
      // emit(UserDataSuccess(user: user));
    });

    on<UserDataFetchedSuccessEvent>((event, emit) {
      emit(UserDataSuccess(user: event.info));
    });
  }

  void _loadData() {
    _infoSubscription?.cancel();
    _infoSubscription = info.listen((user) {
      print(user.name);
      add(UserDataFetchedSuccessEvent(info: user));
    });
  }

  @override
  Future<void> close() {
    print("close");
    _infoSubscription?.cancel();
    return super.close();
  }
}
