import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sleer/config/config_images.dart';
import 'package:sleer/screens/components/app_text_field.dart';
import 'package:sleer/screens/components/avatar/cpn_avatar_holder.dart';
import 'package:sleer/screens/components/background_label.dart';
import 'package:sleer/screens/components/vertical_scroll_layout.dart';
import 'package:sleer/services/api_service.dart';

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
    _initializeControllerFuture = _initializeCamera();
    // _getPost();
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

  Future<void> _getPost() async {
    try {
      final token = apiService.getToken();
      debugPrint('getToken: $token');
      final Response = await apiService.request(
        '/post/',
        options: Options(method: 'GET'),
      );
    } catch (e) {
      debugPrint('Error new post: $e');
    }
  }

  Future<void> _newPost() async {
    try {
      if (picture != null) {
        FormData formData = FormData.fromMap({
          'content': content.text, // 'content': 'lock wat i got ♥',
          'image': await MultipartFile.fromFile(picture!.path),
        });
        final Response = await apiService.request(
          '/post/new',
          data: formData,
          options: Options(method: 'POST', contentType: 'multipart/form-data'),
        );
      }
    } catch (e) {
      debugPrint('Error new post: $e');
    }
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
        widget: Column(
          children: [
            Stack(
              children: [
                if (picture == null)
                  Positioned(
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            decoration: const BoxDecoration(),
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            child: CameraPreview(_controller),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
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
                onPressed: _newPost,
                child: const Icon(Icons.check_circle_outline_outlined),
              ),
          ],
        ),
      ),
    );
  }
}
