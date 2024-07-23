import 'package:sleer/models/post.dart';

abstract class PostState {
  List<Post> listPost;
  PostState({required this.listPost});
}

class PostInitial extends PostState {
  PostInitial({required super.listPost});
}

// these class are useless ???
// class PostUploadingState extends PostState {}
// class PostFetchingState extends PostState {}
class PostFetchedState extends PostState {
  PostFetchedState({required super.listPost});
}

class PostErrorState extends PostState {
  PostErrorState({required super.listPost});
}
