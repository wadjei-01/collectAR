import 'dart:io' as io;

import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/arsession/gallery/gallery_view.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:slide_switcher/slide_switcher.dart';
import '../theme/globals.dart';
import 'arsession_controller.dart';

class ARSessionView extends StatefulWidget {
  ARSessionView({Key? key}) : super(key: key);
  @override
  _ARSessionViewState createState() => _ARSessionViewState();
}

class _ARSessionViewState extends State<ARSessionView> {
  final controller = Get.put(ARSessionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.secondary,
          elevation: 0,
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150.r),
                color: Colors.white),
            child: IconButton(
              icon: Icon(Icons.chevron_left_rounded),
              onPressed: () {
                controller.dispose();
                Get.back();
              },
              iconSize: 70.r,
              color: AppColors.secondary,
            ),
          ),
          actions: [
            Obx(() {
              return controller.isTapped.isTrue
                  ? GestureDetector(
                      child: Center(
                        child: Container(
                            margin: EdgeInsets.only(right: 50.w),
                            width: 100.r,
                            height: 100.r,
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(50.r)),
                            child: Icon(Ionicons.close, color: Colors.white)),
                      ),
                      onTap: () => controller.deleteModel(),
                    )
                  : SizedBox();
            })
          ],
        ),
        body: Container(
            child: Stack(children: [
          ARView(
            onARViewCreated: controller.onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              alignment: AlignmentDirectional.topCenter,
              height: 0.17.sh,
              width: 1.sw,
              color: Colors.black.withOpacity(0.4),
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: SlideSwitcher(
                    children: [
                      Icon(
                        Ionicons.albums_sharp,
                        color: Colors.black,
                      ),
                      Icon(
                        Ionicons.camera_sharp,
                        color: Colors.black,
                      ),
                    ],
                    containerColor: Color.fromARGB(255, 234, 234, 234),
                    slidersColors: [AppColors.primary],
                    containerHeight: 100.h,
                    containerWight: 350.w,
                    onSelect: (index) {
                      controller.focusIndex(index);
                    }),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            heightFactor: controller.heightFactor,
            child: SizedBox(
                height: 200.r,
                child: Obx(() => controller.focusIndex.value != 0
                    ? InkWell(
                        onTap: () => controller.onTakeScreenshot(context),
                        child: Container(
                          height: 200.r,
                          width: 200.r,
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(100.r),
                              border:
                                  Border.all(color: Colors.white, width: 5)),
                        ),
                      )
                    : ScrollSnapList(
                        itemSize: 200.r,
                        itemCount: controller.productList.length,
                        dynamicItemSize: true,
                        onItemFocus: controller.onItemFocus,
                        itemBuilder: (context, index) => controller.buildList(
                            context, index, controller.productList),
                      ))),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            heightFactor: controller.heightFactor + 1.9,
            child: SizedBox(
                height: 170.r,
                child: Obx(() => controller.focusIndex.value != 0
                    ? FutureBuilder(
                        future: controller.getLastImage(),
                        builder:
                            (BuildContext context, AsyncSnapshot<Uri?> file) {
                          if (file.hasData) {
                            return InkWell(
                                onTap: () async {
                                  Get.to(GalleryView(),
                                      arguments: await controller.getGallery());
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 150.w),
                                    clipBehavior: Clip.hardEdge,
                                    height: 170.r,
                                    width: 170.r,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                    ),
                                    child: Obx(() => Image.file(
                                          (io.File(controller.uri.value!.path)),
                                          fit: BoxFit.cover,
                                        ))));
                          } else {
                            return Container(
                                height: 170.r,
                                width: 170.r,
                                margin: EdgeInsets.only(left: 150.w),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100.r),
                                ));
                          }
                        })
                    : SizedBox())),
          ),
          Align(
            alignment: Alignment.bottomRight,
            heightFactor: 20.7,
            child: GestureDetector(
              onTap: () => controller.planesSwitch(),
              child: Obx(() {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                  height: 100.r,
                  width: 100.r,
                  decoration: BoxDecoration(
                      color: controller.isPlanesShown.isTrue
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50.r)),
                  child: Icon(
                    Ionicons.apps,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Obx(() {
              return controller.isLoading.isTrue
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Loading",
                          style: MediumHeaderStyle(
                              color: Colors.white, fontSize: 50.sp),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        LoadingIndicator(),
                      ],
                    )
                  : SizedBox();
            }),
          ),
          Align(
            alignment: Alignment.center,
            child: Obx(() {
              return controller.isPictureLoading.isTrue
                  ? LoadingIndicator(
                      progress: controller.progress.value,
                    )
                  : SizedBox();
            }),
          ),
          Obx(() {
            return controller.focusIndex.value != 0
                ? SizedBox()
                : Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    heightFactor: controller.heightFactor,
                    child: Container(
                      height: 200.r,
                      width: 200.r,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(color: Colors.white, width: 5)),
                    ));
          })
        ])));
  }
}

// import 'dart:math';
// import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:navbar/otherpages/arsession/arsession_controller.dart';
// import 'package:navbar/otherpages/globals.dart';
// import 'package:navbar/widgets.dart';
// import 'package:scroll_snap_list/scroll_snap_list.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;

// import '../productpage/product_model.dart';

// class ARSessionView extends GetView {
//   const ARSessionView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ARSessionController());
//     return Scaffold(
//       appBar: AppBar(
//         leading: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50.r), color: Colors.white),
//           child: IconButton(
//             icon: Icon(Icons.chevron_left_rounded),
//             onPressed: () {
//               Get.back();
//             },
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: Stack(children: [
//         ArCoreView(
//           onArCoreViewCreated: controller.onArCoreViewCreated,
//           enableTapRecognizer: true,
//           enablePlaneRenderer: true,
//         ),
//         Align(
//           alignment: AlignmentDirectional.bottomCenter,
//           heightFactor: 10,
//           child: SizedBox(
//               height: 200.h,
//               child: ScrollSnapList(
//                 itemSize: 200.r,
//                 itemCount: controller.data.length,
//                 dynamicItemSize: true,
//                 onItemFocus: controller.onItemFocus,
//                 itemBuilder: (context, index) =>
//                     controller.buildList(context, index, controller.data),
//               )),
//         )
//       ]),
//     );
//   }
// }
