import 'package:get/get.dart';
import 'package:guatchos/view/demo_vm.dart';
import 'package:guatchos/watch_comm_manager.dart';

class DemoPageController extends GetxController {
  DemoPageController();
  final DemoPageVm demoPageVm = Get.find<DemoPageVm>();

  void increment() {
    demoPageVm.counter++;
    // Add code to send updated count to WatchOS
    final WatchOsCommManager watchCommManager = Get.find<WatchOsCommManager>();
    watchCommManager.sendCountToWatchOS(demoPageVm.counter.value);
  }
}
