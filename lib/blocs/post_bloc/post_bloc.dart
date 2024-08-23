import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/post_bloc/post_event.dart';
import 'package:sleer/blocs/post_bloc/post_state.dart';
import 'package:sleer/models/post.dart';
import 'package:sleer/services/shared_pref_service.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  // final SharedPrefService _pref;
  final _pref = SharedPrefService();
  PostBloc() : super(PostInitial()) {
    on<LoadPostEvent>(_onLoadPosts);
    // on<AddPost>(_onAddPost);
    on<NewPostReceivedEvent>(_onNewPostReceived);
    add(LoadPostEvent());
  }

  Future<void> _onLoadPosts(
      LoadPostEvent event, Emitter<PostState> emit) async {
    final cachedPosts = await _pref.getListPosts();
    emit(PostLoaded(posts: cachedPosts));
  }

  // void _onAddPost(AddPost event, Emitter<PostsState> emit) async {
  //   if (state is PostsLoaded) {
  //     final currentState = state as PostsLoaded;
  //     final updatedPosts = List<Post>.from(currentState.posts)..add(event.post);
  //     await sharedPrefService.savePosts(updatedPosts); // Save to cache
  //     emit(currentState.copyWith(posts: updatedPosts));
  //   }
  // }

  void _onNewPostReceived(
    NewPostReceivedEvent event,
    Emitter<PostState> emit,
  ) async {
    if (state is PostLoaded) {
      try {
        final currentState = state as PostLoaded;
        final newPosts = event.posts
            .where((newPost) => !currentState.posts
                .any((existingPost) => existingPost.id == newPost.id))
            .toList();

        if (newPosts.isNotEmpty) {
          final updatedPosts = List<Post>.from(currentState.posts)
            ..addAll(newPosts);
          emit(currentState.copyWith(posts: updatedPosts));
          await _pref.setListPosts(updatedPosts); // Save to cache
        }
      } catch (e) {
        debugPrint("PostBloc _onNewPostReceived: $e");
      }
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sleer/blocs/post_bloc/post_event.dart';
// import 'package:sleer/blocs/post_bloc/post_state.dart';
// import 'package:sleer/services/news_feed_service.dart';
// import 'package:sleer/services/shared_pref_service.dart';

// class PostBloc extends Bloc<PostEvent, PostState> {
//   PostBloc() : super(PostInitial(listPost: [])) {
//     final sharedPrefService = SharedPrefService();
//     on<PostInitialEvent>((event, emit) async {
//       try {
//         emit(
//             PostFetchedState(listPost: await sharedPrefService.getListPosts()));
//       } catch (e) {
//         debugPrint("PostBloc: $e");
//       }
//     });
//     on<PostFetchEvent>((event, emit) async {
//       try {
//         emit(PostFetchedState(listPost: await NewsFeedService().getPost()));
//       } catch (e) {
//         debugPrint("PostBloc: $e");
//       }
//     });
//   }
// }
