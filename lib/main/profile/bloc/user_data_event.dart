part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

class UserDataFetchedEvent extends UserDataEvent {
  const UserDataFetchedEvent();
}

class UserDataFetchedSuccessEvent extends UserDataEvent {
  final Info info;
  const UserDataFetchedSuccessEvent({required this.info});
}
