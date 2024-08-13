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
    final token = await sharedPrefService.getToken();
    debugPrint("token socket: $token");
    socket = IO.io(ConfigApiRoutes.baseWs, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, //default == true
      'extraHeaders': {
        'Authorization': 'Bearer ${token ?? ''}',
        // Add other headers if needed
      }
    });

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

  Future<void> connectGuess() async {
    final token = await sharedPrefService.getToken();
    debugPrint("token socket: $token");
    socket = IO.io(ConfigApiRoutes.baseWs, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true, //default == true
      'extraHeaders': {
        'Authorization': 'Bearer ' '',
        // 'Authorization': 'Bearer ${token ?? ''}',
        // Add other headers if needed
      }
    });

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

  Future<void> connectAuth() async {
    final token = await sharedPrefService.getToken();
    debugPrint("token socket: $token");
    socket = IO.io(ConfigApiRoutes.baseWs, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, //default == true
      'extraHeaders': {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjA5NDgwMjU0NTUiLCJpYXQiOjE3MjM1ODM2OTAsImV4cCI6MTcyNDAxNTY5MH0.62OqsRHDjCXLdGZh_S7tLT1DuexVCOW5g9ILbskom9Y',
        // 'Authorization': 'Bearer ${token ?? ''}',
        // Add other headers if needed
      }
    });

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

  bool isConnected() {
    return socket?.connected ?? false;
  }

  reconnect() async {
    if (socket != null) {
      debugPrint("Reconnecting existing socket...");
      await disconnect();
      await connect();

      // socket!.io
      //   ..disconnect()
      //   ..connect();
    } else {
      debugPrint("Socket is null. Attempting to create a new connection...");
    }
  }

  disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
