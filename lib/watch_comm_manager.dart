import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guatchos/watch_data_sample.dart';
import 'package:guatchos/view/demo_vm.dart';

class WatchOsCommManager extends GetxController {
  static const MethodChannel _channel = MethodChannel('FlutterToWatchOS');
  late DemoPageVm _demoPageVm;

  void init() {
    _demoPageVm = Get.find<DemoPageVm>();
    sendInitialValuesToWatchOS();
    sendImageToWatchOS('assets/logo.png');

    _channel.setMethodCallHandler((call) async {
      if (call.method == "receiveMessageFromWatchOS") {
        final String message = call.arguments;
        handleReceivedMessage(message);
      }
    });
  }

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

  Future<void> sendImageToWatchOS(String assetName) async {
    try {

      final ByteData assetData = await rootBundle.load(assetName);
      final Uint8List pngData = assetData.buffer.asUint8List();

      await _channel.invokeMethod('sendImageToWatchOS', pngData);
    } catch (e) {
      print("Failed to send image to WatchOS: $e");
    }
  }

  Future<void> sendCountToWatchOS(int count) async {
    try {
      await _channel.invokeMethod('sendCountToWatchOS', count);
    } catch (e) {
      log("Failed to send count to WatchOS: $e");
    }
  }

  Future<void> sendMessageToWatchOS(String message) async {
    try {
      await _channel.invokeMethod('sendMessageToWatchOS', message);
    } catch (e) {
      log("Failed to send message to WatchOS: $e");
    }
  }

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

  void handleReceivedMessage(String message) {
    Get.showSnackbar(
        GetSnackBar(title: "WatchOS",  message: "$message",snackPosition: SnackPosition.TOP,duration: 1.seconds,)
    );
  }
}

