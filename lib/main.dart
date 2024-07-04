import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:guatchos/view/demo_controller.dart';
import 'package:guatchos/view/demo_view.dart';
import 'package:guatchos/view/demo_vm.dart';
import 'package:guatchos/watch_comm_manager.dart';

Future<void> main() async {
  await AppManager.initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter WatchOS Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoPageView(title: 'Flutter WatchOS companion'),
    );
  }
}

class AppManager {
  AppManager._();

  static Future<void> initializeDependencies() async {
    Get.put(DemoPageVm());
    Get.put(DemoPageController());
    final WatchOsCommManager watchCommManager = Get.put(WatchOsCommManager());
    watchCommManager.init();
  }
}
