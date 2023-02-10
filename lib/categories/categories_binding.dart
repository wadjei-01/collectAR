import 'package:get/get.dart';
import 'package:navbar/categories/categoriescontroller.dart';

class CategoriesBindings extends Bindings {
  @override
  void dependencies() {
    final controller = Get.put(CategoriesController());
  }
}
