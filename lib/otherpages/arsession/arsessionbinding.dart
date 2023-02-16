import 'package:get/get.dart';
import 'package:navbar/otherpages/arsession/arsession_controller.dart';
import 'package:navbar/otherpages/productpage/product_controller.dart';

class ARSessionBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ARSessionController>(ARSessionController());
  }
}
