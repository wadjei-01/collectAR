import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:get/get.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';

class ARSessionController extends GetxController {
  late ArCoreController arCoreController;
  List<Product> data = Get.arguments;
  RxInt focusedIndex = 0.obs;
  void onItemFocus(int index) {
    focusedIndex(index);
  }

  void onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _addProduct(ArCoreHitTestResult? plane) {
    if (plane != null) {
      try {
        print(data[focusedIndex.value].modelAR);
        final nodeObject = ArCoreReferenceNode(
            name: data[focusedIndex.value].name,
            objectUrl:
                "https://raw.githubusercontent.com/wadjei-01/collectAR/master/assets/Chicken_01/Chicken_01.gltf?token=GHSAT0AAAAAAB46H2OVJFRXUWRLDDCYVZS4Y7RJNVA"
            // "${data[focusedIndex.value].modelAR}"
            ,
            position: plane.pose.translation,
            rotation: plane.pose.rotation);

        arCoreController.addArCoreNode(nodeObject);
      } catch (e) {
        print("Errorrr!!" + e.toString());
      }
    }
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    if (hits.isNotEmpty) {
      final hit = hits.first;

      _addProduct(hit);
    }
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
