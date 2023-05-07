import 'package:get/get.dart';
import 'package:navbar/arsession/arsession_controller.dart';

class ARSessionBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ARSessionController>(ARSessionController());
  }
}
