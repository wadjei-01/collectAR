import 'dart:math';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navbar/otherpages/arsession/arsession_controller.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/widgets.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../productpage/product_model.dart';

class ARSessionView extends GetView {
  const ARSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ARSessionController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(children: [
        ArCoreView(
          onArCoreViewCreated: controller.onArCoreViewCreated,
          enableTapRecognizer: true,
          enablePlaneRenderer: true,
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          heightFactor: 10,
          child: SizedBox(
              height: 200.h,
              child: ScrollSnapList(
                itemSize: 200.r,
                itemCount: controller.data.length,
                dynamicItemSize: true,
                onItemFocus: controller.onItemFocus,
                itemBuilder: (context, index) =>
                    buildList(context, index, controller.data),
              )),
        )
      ]),
    );
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
              color: AppColors.title),
          child: CachedNetworkImage(
            imageUrl: data[index].images[0],
          )),
    );
  }
}
