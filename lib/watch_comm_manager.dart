import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guatchos/user_model_sample.dart';
import 'package:guatchos/view/demo_vm.dart';

/// This class manages Native<->Flutter method channel handlers
class WatchOsCommManager extends GetxController {
  // Channel is shared between Flutter and Native layers
  static const MethodChannel _channelData = MethodChannel('FlutterToWatchOSData');
  static const MethodChannel _channelComms = MethodChannel('FlutterToWatchOSComms');
  final DemoPageVm _demoPageVm = Get.find<DemoPageVm>();

  void init() {
    // Send initial Data and Image
    sendDataValuesToWatchOS();

    // Handler for receiving data calls from WatchOS
    _channelData.setMethodCallHandler((call) async {
      switch (call.method) {
        case "receiveMessageFromWatchOS":
          final String message = call.arguments;
          handleReceivedMessage(message);
          break;
        default:
          log("Unknown data method: ${call.method}");
      }
    });

    // Handler for receiving comm state calls from WatchOS
    _channelComms.setMethodCallHandler((call) async {
      switch (call.method) {
        case "updateWatchOS":
          updateWatchOS();
          break;
        default:
          log("Unknown comms method: ${call.method}");
      }
    });
  }

  // Handle request update from watchOS
  void updateWatchOS() async {
    log("Handling update request from watchOS");
    try {
      sendDataValuesToWatchOS();
    } catch (e){
      log("$e");
    }
  }

  // Send a set of data
  Future<void> sendDataValuesToWatchOS() async {
    try {
      sendUserToWatchOS(_demoPageVm.user.value);
      sendCountToWatchOS(_demoPageVm.counter.value);
      sendMessageToWatchOS('Hello from Flutter');
      sendImageToWatchOS('assets/logo.png');
    } catch (e) {
      log("Failed to send data values to WatchOS: $e");
    }
  }

  // Send a notification to watch
  Future<void> sendNotificationToWatchOS(String title, String body) async {
    try {
      await _channelData.invokeMethod('sendNotificationToWatchOS', {
        'title': title,
        'body': body,
      });
    } on PlatformException catch (e) {
      log("Failed to send notification: '${e.message}'.");
    }
  }

  // Send a png image
  Future<void> sendImageToWatchOS(String assetName) async {
    try {
      final ByteData assetData = await rootBundle.load(assetName);
      final Uint8List pngData = assetData.buffer.asUint8List();

      await _channelData.invokeMethod('sendImageToWatchOS', pngData);
    } catch (e) {
      log("Failed to send image to WatchOS: $e");
    }
  }

  // Send a count integer
  Future<void> sendCountToWatchOS(int count) async {
    try {
      await _channelData.invokeMethod('sendCountToWatchOS', count);
    } catch (e) {
      log("Failed to send count to WatchOS: $e");
    }
  }

  // Send a String message
  Future<void> sendMessageToWatchOS(String message) async {
    try {
      await _channelData.invokeMethod('sendMessageToWatchOS', message);
    } catch (e) {
      log("Failed to send message to WatchOS: $e");
    }
  }

  // Send user object
  Future<void> sendUserToWatchOS(User user) async {
    try {
      await _channelData.invokeMethod('sendUserToWatchOS', {
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
