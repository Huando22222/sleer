import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/post_bloc/post_event.dart';
import 'package:sleer/blocs/post_bloc/post_state.dart';
import 'package:sleer/services/news_feed_service.dart';
import 'package:sleer/services/shared_pref_service.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial(listPost: [])) {
    final sharedPrefService = SharedPrefService();
    on<PostFetchEvent>((event, emit) async {
      try {
        emit(PostFetchedState(listPost: await NewsFeedService.getPost()));
      } catch (e) {
        debugPrint("PostBloc: $e");
      }
    });
    on<PostInitialEvent>((event, emit) async {
      try {
        emit(
            PostFetchedState(listPost: await sharedPrefService.getListPosts()));
      } catch (e) {
        debugPrint("PostBloc: $e");
      }
    });
  }
}
