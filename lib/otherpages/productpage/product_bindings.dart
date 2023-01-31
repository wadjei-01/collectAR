import 'package:get/get.dart';
import 'package:navbar/otherpages/productpage/product_controller.dart';

class ProductBindings implements Bindings {
  @override
  void dependencies() {
    Get.create<ProductController>(() => ProductController());
    // Get.put<ProductController>(ProductController(), tag: 'price');
  }
}
