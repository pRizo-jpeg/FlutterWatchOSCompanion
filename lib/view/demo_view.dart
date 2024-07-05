import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guatchos/view/demo_controller.dart';
import 'package:guatchos/view/demo_vm.dart';

class DemoPageView extends StatelessWidget {
  const DemoPageView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final DemoPageController demoController = Get.find<DemoPageController>();
    final DemoPageVm demoPageVm = demoController.demoPageVm;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/logo.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the + button this many times:'),
                Obx(() => Text(
                      '${demoPageVm.counter}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    )),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: ElevatedButton(
              onPressed: demoController.sendNotification,
              style: ElevatedButton.styleFrom(
                elevation: 8,
                backgroundColor: Colors.blue.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notification_add,
                      color: Colors.black,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Queue a notification\ntakes ~10 seconds",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: demoController.increment,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
