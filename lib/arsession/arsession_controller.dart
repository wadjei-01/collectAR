import 'dart:async';
import 'dart:io' as io;

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
import 'package:navbar/widgets.dart';

import 'package:vector_math/vector_math_64.dart' as math;

import '../theme/globals.dart';
import '../productpage/product_model.dart';

class ARSessionController extends GetxController {
  List<Product> productList = Get.arguments;

  String path = '/storage/emulated/0/DCIM/collectAR';
  RxInt focusedIndex = 0.obs;
  double heightFactor = 11.5;

  RxBool isLoading = false.obs;
  RxBool isPictureLoading = false.obs;
  int _loadingTime = 3;
  late Timer _timer;

  RxDouble progress = 0.0.obs;
  RxBool isTapped = false.obs;
  RxBool isPlanesShown = true.obs;
  Rx<Uri?> uri = Uri().obs;

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
    onRemoveEverything();
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

// Initialises the session
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
          showPlanes: isPlanesShown.value,
          showWorldOrigin: false,
        );
    arObjectManager.onInitialize();

    arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    arObjectManager.onNodeTap = onNodeTapped;
    arObjectManager.onPanStart = onPanStarted;
    arObjectManager.onPanChange = onPanChanged;
    arObjectManager.onPanEnd = onPanEnded;
    arObjectManager.onRotationStart = onRotationStarted;
    arObjectManager.onRotationChange = onRotationChanged;
    arObjectManager.onRotationEnd = onRotationEnded;
  }

  void updateSessionSettings() {
    arSessionManager!.onInitialize(
      showAnimatedGuide: false,
      showFeaturePoints: false,
      handlePans: true,
      handleRotation: true,
      handleTaps: true,
      showPlanes: isPlanesShown.value,
      showWorldOrigin: false,
    );
    arObjectManager!.onInitialize();

    arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    arObjectManager!.onNodeTap = onNodeTapped;
    arObjectManager!.onPanStart = onPanStarted;
    arObjectManager!.onPanChange = onPanChanged;
    arObjectManager!.onPanEnd = onPanEnded;
    arObjectManager!.onRotationStart = onRotationStarted;
    arObjectManager!.onRotationChange = onRotationChanged;
    arObjectManager!.onRotationEnd = onRotationEnded;
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
  }

  Future<void> deleteModel() async {
    this.arObjectManager!.removeNode(selectedNode);

    int index = nodes.indexOf(selectedNode);
    this.arAnchorManager!.removeAnchor(anchors.elementAt(index));

    nodes.remove(selectedNode);
    anchors.removeAt(index);
    isTapped(false);

    update();
  }

  void planesSwitch() {
    isPlanesShown(!isPlanesShown.value);
    updateSessionSettings();
  }

  Future<void> isPictureLoadingSwitch() async {
    isPictureLoading(true);
    timeValue();
    update();
  }

  void timeValue() {
    _timer = Timer.periodic(Duration(milliseconds: _loadingTime * 10), (t) {
      progress(progress.value + 0.01);
      print('value is: ${progress.value}');
      if (progress.value >= 1.0) {
        _timer.cancel();
        isPictureLoading(false);
        progress(0.00);
      }
    });
  }

  Future<void> onTakeScreenshot(BuildContext context) async {
    isPictureLoadingSwitch();
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

    update();
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
    uri(await getLastImage());
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
            uri: productList[focusedIndex.value].modelAR,
            scale: math.Vector3(1, 1, 1),
            position: math.Vector3(0.0, 0.0, 0.0),
            rotation: math.Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor =
            await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        isLoading(false);

        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        arSessionManager!.onError("Adding Anchor failed");
      }
    } else {
      Get.snackbar('No plane detected', 'Please try again',
          colorText: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.5));
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
    final pannedNode = nodes.firstWhere((element) => element.name == nodeName);
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode = nodes.firstWhere((element) => element.name == nodeName);

   
  }
}


