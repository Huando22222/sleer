import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleer/config/config_api_routes.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;
  final sharedPrefService = SharedPrefService();

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
      debugPrint('socket on: new_post: $data');
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
