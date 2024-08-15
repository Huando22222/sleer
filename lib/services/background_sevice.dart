import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:sleer/services/socket_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeService() async {
  //bg-service # thread to main app //config socket turn on/off for now , create instance to get cache later
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      autoStartOnBoot: true,

      // notificationChannelId: 'my_foreground',
      // initialNotificationTitle: 'Service is Running',
      // initialNotificationContent: 'Tap to return to the app',
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  final socketClient = SocketClient.instance;
  DartPluginRegistrant.ensureInitialized();
  debugPrint("onStart service bg");

  _initializeSocket();

  service.on('setAsDisconnectSocket').listen((event) {
    socketClient.disconnect();
  });

  //------------------------------------//
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  if (service is IOSServiceInstance) {}

  service.on('stopService').listen((event) {
    socketClient.disconnect();
    service.stopSelf();
  });

  // Timer.periodic(
  //   const Duration(seconds: 1),
  //   (timer) async {
  //     debugPrint("timerr");
  //     if (service is AndroidServiceInstance) {
  //       if (await service.isForegroundService()) {
  //         service.setForegroundNotificationInfo(
  //           title: "tittle",
  //           content: "content",
  //         );
  //       }
  //     }
  //     service.invoke('update');
  //   },
  // );
}

Future<void> _initializeSocket() async {
  try {
    final socketClient = SocketClient.instance;
    await socketClient.connect();
  } catch (e) {
    debugPrint("bgService: $e");
  }
}
