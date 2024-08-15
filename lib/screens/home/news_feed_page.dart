import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sleer/blocs/post_bloc/post_bloc.dart';
import 'package:sleer/blocs/post_bloc/post_event.dart';
import 'package:sleer/blocs/post_bloc/post_state.dart';
import 'package:sleer/config/config_api_routes.dart';
import 'package:sleer/config/config_images.dart';
import 'package:sleer/screens/components/avatar/cpn_avatar_holder.dart';
import 'package:sleer/screens/components/background_label.dart';
import 'package:sleer/screens/components/vertical_scroll_layout.dart';
import 'package:sleer/services/api_service.dart';
import 'package:sleer/services/news_feed_service.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:sleer/services/util_service.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  final TextEditingController content = TextEditingController();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<CameraDescription>? cameras;
  int selectedCameraIndex = 0;
  XFile? picture;

  final apiService = GetIt.instance<ApiService>();

  @override
  void initState() {
    super.initState();
    _fetchPost();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _fetchPost() async {
    var internet = await UtilService.checkInternetConnection();
    if (internet == true) {
      BlocProvider.of<PostBloc>(context).add(PostFetchEvent());
    } else {
      debugPrint("Connectivity isn't connected.");
    }
  }

  Future<void> _refresh() async {
    await _fetchPost();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras![selectedCameraIndex],
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _switchCamera() async {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras!.length;
    await _initializeCamera();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      picture = await _controller.takePicture();
      setState(() {});
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void _deletePicture() {
    setState(() {
      picture = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CpnAvatarHolder(),
        title: InkWell(
          onTap: () {},
          child: const BackgroundLabel(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_drop_down_rounded),
              Text("mọi người"),
            ],
          )),
        ),
        centerTitle: true,
        actions: [
          ClipOval(
            child: InkWell(
              onTap: () {},
              child: Image.asset(ConfigImages.chat),
            ),
          )
        ],
      ),
      body: VerticalScrollLayout(
        onRefresh: _refresh,
        widget: Column(
          children: [
            Stack(
              children: [
                if (picture == null)
                  Positioned(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CameraPreview(_controller);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  )
                else
                  Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(picture!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                if (picture != null)
                  Positioned(
                    right: 20,
                    top: 20,
                    child: InkWell(
                      onTap: _deletePicture,
                      child: const Icon(
                        Icons.highlight_remove,
                        size: 45,
                        color: Colors.red,
                      ),
                    ),
                  )
                else
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: InkWell(
                      onTap: _switchCamera,
                      child: const Icon(
                        Icons.flip_camera_android_sharp,
                        size: 45,
                      ),
                    ),
                  ),
                if (picture != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 50,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: IntrinsicWidth(
                          child: TextField(
                            controller: content,
                            maxLength: 30,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: 'mô tả',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.6),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (picture == null)
              ElevatedButton(
                onPressed: _takePicture,
                child: const Icon(Icons.camera),
              )
            else
              ElevatedButton(
                onPressed: () async {
                  bool isPosted =
                      await NewsFeedService().newPost(picture!, content.text);
                  if (isPosted) {
                    setState(() {
                      picture = null;
                      content.clear();
                    });
                    BlocProvider.of<PostBloc>(context).add(PostFetchEvent());
                  }
                },
                child: const Icon(Icons.check_circle_outline_outlined),
              ),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostFetchedState) {
                  if (state.listPost.isNotEmpty) {
                    debugPrint("image: ${state.listPost[0].image}");
                    return Column(
                      children: [
                        Text(state.listPost[state.listPost.length - 1].content),
                        Image.network(
                            "${ConfigApiRoutes.urlImage}posts/0948025455/9e116b53e642b7a80d2409fa5fe04c0e5a38ac0ed56e242fd9f44829a419dc36.jpg"),
                        CachedNetworkImage(
                          imageUrl:
                              state.listPost[state.listPost.length - 1].image,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ],
                    );
                  }

                  return Text("error data");
                } else {
                  return Text("no data"); //skeleton add later
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
