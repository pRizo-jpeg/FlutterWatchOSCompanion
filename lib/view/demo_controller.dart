import 'package:get/get.dart';
import 'package:guatchos/view/demo_vm.dart';
import 'package:guatchos/watch_comm_manager.dart';

class DemoPageController extends GetxController {
  DemoPageController();

  final DemoPageVm demoPageVm = Get.find<DemoPageVm>();
  final WatchOsCommManager watchCommManager = Get.find<WatchOsCommManager>();

  void increment() {
    demoPageVm.counter++;
    watchCommManager.sendCountToWatchOS(demoPageVm.counter.value);
  }

  void sendNotification() {
    watchCommManager.sendNotificationToWatchOS("Notification", "This is a notification triggered by Flutter");
  }

}
