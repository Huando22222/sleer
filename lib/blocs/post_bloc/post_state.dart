import 'package:sleer/models/post.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded({required this.posts});

  PostLoaded copyWith({
    List<Post>? posts,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
    );
  }
}
