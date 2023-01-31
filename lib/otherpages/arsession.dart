import 'dart:ui';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';
import 'package:navbar/widgets.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';

class ARSession extends StatefulWidget {
  ARSession({super.key, required this.product});
  Product? product;

  @override
  State<ARSession> createState() => _ARSessionState();
}

class _ARSessionState extends State<ARSession> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

//String localObjectReference;
  ARNode? localObjectNode;

//String webObjectReference;
  ARNode? webObjectNode;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARTest'),
      ),
      backgroundColor: Color.fromARGB(255, 210, 210, 210),
      body: Stack(children: [
        ARView(
          onARViewCreated: onARViewCreated,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onWebObjectAtButtonPressed(),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    // 1
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    // 2
    this.arSessionManager.onInitialize(
          showFeaturePoints: true,
          showPlanes: true,
          showWorldOrigin: true,
          handleTaps: false,
        );
    // 3
    this.arObjectManager.onInitialize();
  }

  Future<void> onWebObjectAtButtonPressed() async {
    Vector3? position = Vector3(0.0, 0.0, 0.0);

    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri: widget.product!.modelAR,
          position: position,
          scale: Vector3(0.2, 0.2, 0.2));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }
}
