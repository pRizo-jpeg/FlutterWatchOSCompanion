import 'package:get/get.dart';
import 'package:guatchos/user_model_sample.dart';

class DemoPageVm {
  RxInt counter = 0.obs;
  Rx<User>? user = Rx<User>(User(id: 1, name: 'Pablo'));
  RxString? message = ''.obs;
}
