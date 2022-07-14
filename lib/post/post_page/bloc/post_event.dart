import 'package:cooking_social_network/model/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class NextPostEvent extends PostEvent {
  final Post post;
  const NextPostEvent({required this.post});
}

class PostSEvent extends PostEvent {
  final Post post;
  const PostSEvent({required this.post});
}
