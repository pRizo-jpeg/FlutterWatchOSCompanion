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
}

