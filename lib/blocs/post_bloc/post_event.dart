import 'package:camera/camera.dart';

abstract class PostEvent {}

class PostInitialEvent extends PostEvent {} //get sheredPreference

class PostFetchEvent extends PostEvent {} //api

class PostUploadEvent extends PostEvent {
  // final XFile image;
  // PostUploadEvent({required this.image});
} //XFile : photo
