import 'package:sleer/models/post.dart';

abstract class PostEvent {}

class LoadPostEvent extends PostEvent {}

// class AddPostEvent extends PostEvent {
//   final Post post;

//   AddPostEvent(this.post);
// }

class NewPostReceivedEvent extends PostEvent {
  final List<Post> posts;

  NewPostReceivedEvent(this.posts);
}
