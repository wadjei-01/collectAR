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
      print(data[focusedIndex.value].modelAR);
      final nodeObject = ArCoreReferenceNode(
          objectUrl:
              // "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF/Duck.gltf"
              "https://firebasestorage.googleapis.com/v0/b/navbar-e51ee.appspot.com/o/couch.glb?alt=media&token=35a45e43-427e-45bf-9f94-5541fe31bb94"
          // data[focusedIndex.value].modelAR
          ,
          position: plane.pose.translation,
          rotation: plane.pose.rotation);

      arCoreController.addArCoreNodeWithAnchor(nodeObject);
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
