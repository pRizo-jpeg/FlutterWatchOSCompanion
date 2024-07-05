import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guatchos/user_model_sample.dart';
import 'package:guatchos/view/demo_vm.dart';

/// This class manages Native<->Flutter method channel handlers
class WatchOsCommManager extends GetxController {
  // Channel is shared between Flutter and Native layers
  static const MethodChannel _channel = MethodChannel('FlutterToWatchOS');
  final DemoPageVm _demoPageVm = Get.find<DemoPageVm>();

  void init() {
    // Send initial Data and Image
    sendInitialValuesToWatchOS();
    sendImageToWatchOS('assets/logo.png');

    // Handler for receiving message from WatchOS
    _channel.setMethodCallHandler((call) async {
      if (call.method == "receiveMessageFromWatchOS") {
        final String message = call.arguments;
        handleReceivedMessage(message);
      }
    });
  }

  // Send a notification to watch
  Future<void> sendNotificationToWatchOS(String title, String body) async {
    try {
      await _channel.invokeMethod('sendNotificationToWatchOS', {
        'title': title,
        'body': body,
      });
    } on PlatformException catch (e) {
      log("Failed to send notification: '${e.message}'.");
    }
  }

  // Send a set of initial data
  Future<void> sendInitialValuesToWatchOS() async {
    try {
      await _channel.invokeMethod('sendInitialValuesToWatchOS', {
        'count': 0,
        'message': 'Hello from Flutter',
        'user': {
          'name': _demoPageVm.user?.value.name,
          'id': _demoPageVm.user?.value.id,
        },
      });
    } catch (e) {
      log("Failed to send initial values to WatchOS: $e");
    }
  }

  // Send a png image
  Future<void> sendImageToWatchOS(String assetName) async {
    try {
      final ByteData assetData = await rootBundle.load(assetName);
      final Uint8List pngData = assetData.buffer.asUint8List();

      await _channel.invokeMethod('sendImageToWatchOS', pngData);
    } catch (e) {
      log("Failed to send image to WatchOS: $e");
    }
  }

  // Send a count integer
  Future<void> sendCountToWatchOS(int count) async {
    try {
      await _channel.invokeMethod('sendCountToWatchOS', count);
    } catch (e) {
      log("Failed to send count to WatchOS: $e");
    }
  }

  // Send a String message
  Future<void> sendMessageToWatchOS(String message) async {
    try {
      await _channel.invokeMethod('sendMessageToWatchOS', message);
    } catch (e) {
      log("Failed to send message to WatchOS: $e");
    }
  }

  // Send user object
  Future<void> sendUserToWatchOS(User user) async {
    try {
      await _channel.invokeMethod('sendUserToWatchOS', {
        'name': user.name,
        'id': user.id,
      });
    } catch (e) {
      log("Failed to send user to WatchOS: $e");
    }
  }

  // Handle received message from watchOS to display a snack
  void handleReceivedMessage(String message) {
    Get.showSnackbar(GetSnackBar(
      title: "WatchOS",
      message: message,
      snackPosition: SnackPosition.TOP,
      duration: 1.seconds,
    ));
  }
}
