import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guatchos/user_model_sample.dart';
import 'package:guatchos/view/demo_vm.dart';

/// This class manages Native<->Flutter method channel handlers
class WatchOsCommManager extends GetxController {
  // Channel is shared between Flutter and Native layers
  static const MethodChannel _channelData =
      MethodChannel('FlutterToWatchOSData');
  static const MethodChannel _channelComms =
      MethodChannel('FlutterToWatchOSComms');
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
        case "updateWatchOS":
          updateWatchOS();
          break;

        default:
          log("Unknown data method: ${call.method}");
      }
    });
  }

  // Send a commState message
  Future<void> sendResponse({required CommState commState, String? error}) async {
    try {
      await _channelComms.invokeMethod('response', error != null ? "${commState.toString()} $error" : commState.toString());
    } catch (e) {
      log("Failed to send response to WatchOS: $e");
    }
  }

  // Handle request update from watchOS
  void updateWatchOS() async {
    log("Handling update request from watchOS");
    try {
      sendDataValuesToWatchOS();
      sendResponse(commState: CommState.ok);
    } catch (e) {
      log("$e");
      sendResponse(commState: CommState.error, error: e.toString());

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
      sendResponse(commState: CommState.error, error: e.toString());

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
      sendResponse(commState: CommState.error, error: e.toString());

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
      sendResponse(commState: CommState.error, error: e.toString());

    }
  }

  // Send a count integer
  Future<void> sendCountToWatchOS(int count) async {
    try {
      await _channelData.invokeMethod('sendCountToWatchOS', count);

    } catch (e) {
      log("Failed to send count to WatchOS: $e");
      sendResponse(commState: CommState.error, error: e.toString());

    }
  }

  // Send a String message
  Future<void> sendMessageToWatchOS(String message) async {
    try {
      await _channelData.invokeMethod('sendMessageToWatchOS', message);

    } catch (e) {
      log("Failed to send message to WatchOS: $e");
      sendResponse(commState: CommState.error, error: e.toString());

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
      sendResponse(commState: CommState.error, error: e.toString());

    }
  }

  // Handle received message from watchOS to display a snack
  void handleReceivedMessage(String message) {
    try{
      Get.showSnackbar(GetSnackBar(
        title: "WatchOS",
        message: message,
        snackPosition: SnackPosition.TOP,
        duration: 1.seconds,
      ));
      sendResponse(commState: CommState.ok);
    } catch (e){
      sendResponse(commState: CommState.error, error: e.toString());
    }

  }
}

enum CommState {
  ok,
  error;

  @override
  String toString() {
    switch (this) {
      case CommState.ok:
        return 'ok';
      case CommState.error:
        return 'error';
    }
  }
}
