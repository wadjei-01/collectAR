import 'dart:io' as io;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';

import 'package:vector_math/vector_math_64.dart' as math;

import '../globals.dart';

class ARSessionController extends GetxController {
  // late ArCoreController arCoreController;
  List<Product> data = Get.arguments;
  String path = '/storage/emulated/0/DCIM/collectAR';
  RxInt focusedIndex = 0.obs;
  double heightFactor = 11.5;
  RxBool isLoading = false.obs;
  RxBool isTapped = false.obs;
  Rx<Uri?> uriX = Uri().obs;
  Uri uri = Uri();
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  ARNode selectedNode = ARNode(type: NodeType.webGLB, uri: "");
  RxBool takePicture = false.obs;
  RxInt focusIndex = 0.obs;

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  void onItemFocus(int index) {
    focusedIndex(index);
  }

  Widget buildList(BuildContext context, int index, List<Product> data) {
    return SizedBox(
      width: 200.r,
      height: 100.r,
      child: Container(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              color: HexColor(data[index].imageColour)),
          child: CachedNetworkImage(
            imageUrl: data[index].images[0],
            fit: BoxFit.fitWidth,
            width: 130.r,
          )),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showAnimatedGuide: false,
          showFeaturePoints: false,
          handlePans: true,
          handleRotation: true,
          handleTaps: true,
          showPlanes: true,
          showWorldOrigin: false,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onNodeTap = onNodeTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;
  }

  Future<void> onRemoveEverything() async {
    nodes.forEach((node) {
      this.arObjectManager!.removeNode(node);
    });
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onNodeTapped(List<String> nodeName) async {
    var objectTapped =
        nodes.firstWhere((element) => element.name == nodeName.first);

    if (objectTapped == selectedNode) {
      isTapped(!isTapped.value);
    } else {
      isTapped(true);
    }

    selectedNode = objectTapped;

    // this.arSessionManager!.onError("Tapped $nodes node(s)");
  }

  Future<void> removeNode() async {
    this.arObjectManager!.removeNode(selectedNode);

    int index = nodes.indexOf(selectedNode);
    this.arAnchorManager!.removeAnchor(anchors.elementAt(index));

    nodes.remove(selectedNode);
    anchors.removeAt(index);

    if (nodes.isEmpty) {
      isTapped(false);
    }
    update();
  }

  changeBottomFocus() {
    takePicture(!takePicture.value);
  }

  Future<void> onTakeScreenshot(BuildContext context) async {
    var image = await arSessionManager!.snapshot() as MemoryImage;
    MemoryImage img = image as MemoryImage;

    if (await io.Directory(path).exists()) {
      io.File('$path/${DateTime.now().millisecondsSinceEpoch}.png')
          .writeAsBytesSync(img.bytes);
    } else {
      io.Directory(path).create().then((io.Directory directory) {
        print(directory.path);
      });
      io.File('$path/${DateTime.now().millisecondsSinceEpoch}.png')
          .writeAsBytesSync(img.bytes);
    }
    updateURI();
  }

  Future<dynamic> getGallery() async {
    if (await io.Directory(path).exists()) {
      io.Directory dir = io.Directory(path);
      List<io.FileSystemEntity> images = dir.listSync(recursive: true);
      return images;
    } else {
      return null;
    }
  }

  Future<Uri?> getLastImage() async {
    List<io.FileSystemEntity?> files = await getGallery();
    if (files.isEmpty) {
      return null;
    } else {
      Uri uri = files.last!.uri;
      return uri;
    }
  }

  void updateURI() async {
    uriX(await getLastImage());
    update();
  }

  @override
  void onInit() async {
    updateURI();
    super.onInit();
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhereOrNull(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      isLoading(true);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor

        var newNode = ARNode(
            type: NodeType.webGLB,
            uri: data[focusedIndex.value].modelAR,
            scale: math.Vector3(1, 1, 1),
            position: math.Vector3(0.0, 0.0, 0.0),
            rotation: math.Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        isLoading(false);

        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    final pannedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }
}

// class ARSessionController extends GetxController {
//   late ArCoreController arCoreController;

//   List<Product> data = Get.arguments;
//   RxInt focusedIndex = 0.obs;
//   double heightFactor = 13;

//   void onItemFocus(int index) {
//     focusedIndex(index);
//   }

//   void onArCoreViewCreated(ArCoreController controller) {
//     arCoreController = controller;
//     arCoreController.onPlaneTap = _handleOnPlaneTap;
//   }

//   Widget buildList(BuildContext context, int index, List<Product> data) {
//     return SizedBox(
//       width: 200.r,
//       height: 100.r,
//       child: Container(
//           clipBehavior: Clip.antiAlias,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(100.r),
//               color: HexColor(data[index].imageColour)),
//           child: CachedNetworkImage(
//             imageUrl: data[index].images[0],
//             fit: BoxFit.fitWidth,
//             width: 130.r,
//           )),
//     );
//   }

//   void _addProduct(ArCoreHitTestResult? plane) {
//     if (plane != null) {
//       try {
//         print(data[focusedIndex.value].modelAR);
//         final nodeObject = ArCoreReferenceNode(
//             name: data[focusedIndex.value].name,
//             objectUrl:
//                 // "https://github.com/wadjei-01/collectAR/blob/master/assets/images/out.glb?raw=true"
//                 "${data[focusedIndex.value].modelAR}",
//             position: plane.pose.translation,
//             rotation: plane.pose.rotation);

//         arCoreController.addArCoreNode(nodeObject);
//       } catch (e) {
//         print("Errorrr!!" + e.toString());
//       }
//     }
//   }

//   void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
//     if (hits.isNotEmpty) {
//       final hit = hits.first;

//       _addProduct(hit);
//     }
//   }

//   @override
//   void dispose() {
//     arCoreController.dispose();
//     super.dispose();
//   }
// }
