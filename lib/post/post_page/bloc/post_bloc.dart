import 'package:cooking_social_network/post/post_page/bloc/post_event.dart';
import 'package:cooking_social_network/post/post_page/bloc/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<NextPostEvent>((event, emit) {
      emit(PostNextPage(post: event.post));
    });
    on<PostSEvent>((event, emit) {
      emit(PostsState(post: event.post));
    });
  }
}
