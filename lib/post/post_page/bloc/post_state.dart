import 'package:cooking_social_network/model/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostNextPage extends PostState {
  final Post post;
  const PostNextPage({required this.post});
}

class PostsState extends PostState {
  final Post post;
  const PostsState({required this.post});
}

class PostSuccessState extends PostState {}

class PostFailState extends PostState {}
