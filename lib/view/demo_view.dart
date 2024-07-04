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
        child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/logo.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                // Use Obx to update the UI when the counter changes
                Obx(() => Text(
                  '${demoPageVm.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
                // Additional UI to display message from WatchOS
                Obx(() => Text(
                  '${demoPageVm.message ?? 'No message'}',
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: demoController.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
