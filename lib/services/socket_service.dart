import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/post_bloc/post_bloc.dart';
import 'package:sleer/blocs/post_bloc/post_event.dart';
import 'package:sleer/config/config_api_routes.dart';
import 'package:sleer/main.dart';
import 'package:sleer/models/post.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;
  final sharedPrefService = SharedPrefService();
  final postBlocGetIt = getIt<PostBloc>();

  SocketClient._internal();

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }

  Future<void> connect() async {
    String? token = await sharedPrefService.getToken();
    debugPrint("token socket: $token");
    socket = IO.io(ConfigApiRoutes.baseWs, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, //default == true
      'extraHeaders': {
        'Authorization': 'Bearer ${token ?? ''}',
        // Add other headers if needed
      }
    });

    _eventListeners();

    socket!.connect();

    socket!.onConnect((data) {
      debugPrint("socket connected: ${socket!.id}");
    });

    socket!.onDisconnect((data) {
      debugPrint("socket Disconnected: ${socket!.id}");
    });

    socket!.onError((error) {
      debugPrint("socket error: $error");
    });
  }

  void _eventListeners() {
    socket?.on('new_post', (data) {
      if (data != null && data is List) {
        try {
          debugPrint('socket on: new_post: ${data.toString()}');
          final newPosts = data.map((post) => Post.fromJson(post)).toList();
          postBlocGetIt.add(NewPostReceivedEvent((newPosts)));
        } catch (e) {
          debugPrint('socket on new_post: $e');
        }
      }
    });

    socket?.on('userJoined', (data) {
      debugPrint('User joined: $data');
    });

    socket?.on('userLeft', (data) {
      debugPrint('User left: $data');
    });
  }

  bool isConnected() {
    return socket?.connected ?? false;
  }

  disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
