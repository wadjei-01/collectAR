import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/collections/collectionpage/collection_page.dart';
import 'package:navbar/collections/collections_controller.dart';
import 'package:navbar/collections/collections_model.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;

import '../box/boxes.dart';
import '../theme/globals.dart';
import '../widgets.dart';
import 'newcollectioncontroller.dart';

class CollectionsView extends GetView<CollectionsController> {
  CollectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionsController = Get.find<CollectionsController>();
    final newCollectionsController = Get.find<NewCollectionsController>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
              controller.product == null ? "Collections" : "Add to Collection",
              style: BoldHeaderstextStyle(
                  fontSize: 55.sp, color: AppColors.secondary)),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black,
                onPressed: () {},
              ),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.secondary,
        ),
        backgroundColor: AppColors.lighten(AppColors.title!, 0.5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.w, right: 30.w),
                child: ValueListenableBuilder<Box<Collections>>(
                    valueListenable: Boxes.getCollections().listenable(),
                    builder: (context, box, _) {
                      return AnimationLimiter(
                          child: (box.length == 0
                              ? Center(
                                  heightFactor: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/emptyCollection.svg',
                                        fit: BoxFit.fitWidth,
                                        width: 500.w,
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Text(
                                        "Nothing... Yet",
                                        style: BoldHeaderstextStyle(
                                            fontSize: 50.sp),
                                      ),
                                    ],
                                  ))
                              : GridView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20.h,
                                    childAspectRatio: 2.w / 1.90.h,
                                    crossAxisSpacing: 20.w,
                                  ),
                                  itemCount: box.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration: Duration(milliseconds: 750),
                                      columnCount: 2,
                                      child: SlideAnimation(
                                        child: FadeInAnimation(
                                          child: GestureDetector(
                                            onTap: () =>
                                                controller.onTap(index),
                                            child: getNewCollectionsContainer(
                                                box,
                                                index,
                                                collectionsController),
                                          ),
                                        ),
                                      ),
                                    );
                                  })));
                    }),
              ),
              SizedBox(
                height: 50.h,
              ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () => newCollectionsController
              .modalBottomsheet(context)
              .whenComplete(() => newCollectionsController.reset()),
          child: Container(
            height: 150.r,
            width: 150.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(75.r),
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2.5,
                  blurRadius: 5,
                  offset: Offset(1, 3), // changes position of shadow
                ),
              ],
            ),
            child: Icon(
              Ionicons.add_circle_sharp,
              color: AppColors.secondary,
              size: 100.r,
            ),
          ),
        ));
  }

  //Old container
  // Container getCollectionsContainer(Box<Collections> box, int index,
  //     CollectionsController collectionsController) {
  //   return Container(
  //     height: 200.h,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(30.r),
  //         color: Color(box.getAt(index)!.color),
  //         image: const DecorationImage(
  //             image: AssetImage('assets/images/gridbg.png'),
  //             fit: BoxFit.cover,
  //             opacity: 0.3)),
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 50.w),
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         SizedBox(
  //           height: 30.h,
  //         ),
  //         SizedBox(
  //           height: 250.h,
  //           child: ImageList(collectionIndex: index),
  //         ),
  //         SizedBox(
  //           width: double.infinity,
  //           child: Text(
  //             box.getAt(index)!.collectionName,
  //             maxLines: 1,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 45.sp,
  //               fontFamily: "Montserrat-SemiBold",
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 10.h,
  //         ),
  //         Row(
  //           children: [
  //             Obx(() => Text(
  //                   collectionsController
  //                       .collectionProductSize(index)
  //                       .value
  //                       .toString(),
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 40.sp,
  //                       fontFamily: 'Montserrat-SemiBold'),
  //                 )),
  //             Text(
  //               collectionsController.collectionProductSize(index) <= 1
  //                   ? ' Product'
  //                   : " Products",
  //               style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 40.sp,
  //                   fontFamily: 'Montserrat-SemiBold'),
  //             ),
  //           ],
  //         )
  //       ]),
  //     ),
  //   );
  // }

  Widget getNewCollectionsContainer(Box<Collections> box, int index,
      CollectionsController collectionsController) {
    return GetBuilder<CollectionsController>(builder: (controller) {
      return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 570.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(color: Colors.white, width: 15.r),
            gradient: LinearGradient(
              colors: [
                Color(controller.collectionsList[index].color + 155),
                Color(controller.collectionsList[index].color),
              ],
              stops: [0, 1],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 1.3,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Stack(children: [
          Positioned.fill(
              child: SvgPicture.asset(
            'assets/images/icons/collectionbg.svg',
            fit: BoxFit.fill,
            height: 250.h,
          )),
          Positioned.fill(
            child: GlassContainer(
              blur: 4,
              color: Colors.white.withOpacity(0.1),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.blue.withOpacity(0.3),
                ],
              ),
              //--code to remove border
              border: Border.fromBorderSide(BorderSide.none),
              shadowStrength: 5,
              shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(16),
              shadowColor: Colors.white.withOpacity(0.24),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: SizedBox(
                  height: 250.h,
                  child: ImageList(collectionIndex: index),
                ),
              ),
            ]),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
                width: 600.w,
                height: 160.h,
                padding: EdgeInsets.only(left: 50.w),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IntrinsicWidth(
                      child: SizedBox(
                        height: 115.h,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(
                            width: 270.w,
                            child: Text(
                              box.getAt(index)!.collectionName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: BoldHeaderstextStyle(
                                  color: Color(collectionsController
                                      .collectionsList[index].color),
                                  fontSize: 45.sp),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Obx(() => Text(
                                  collectionsController
                                      .collectionProductSize(index)
                                      .value
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: BoldHeaderstextStyle(
                                      color: Color(collectionsController
                                          .collectionsList[index].color),
                                      fontSize: 40.sp))),
                              Text(
                                collectionsController
                                            .collectionProductSize(index) <=
                                        1
                                    ? ' Product'
                                    : " Products",
                                style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 40.sp,
                                    fontFamily: 'Montserrat-SemiBold'),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                    PopupMenuButton(
                        onSelected: (value) {
                          if (value == '0') {
                            controller.deleteCollection(index);
                          }
                        },
                        itemBuilder: (context) => [
                              _buildPopupMenuItem('Delete', Ionicons.trash_bin,
                                  collectionsController, index, '0')
                            ])
                  ],
                )),
          )
        ]),
      );
    });
  }

  PopupMenuItem _buildPopupMenuItem(String title, IconData iconData,
      dynamic controller, int index, String value) {
    return PopupMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          SizedBox(
            width: 50.w,
          ),
          Text(title),
        ],
      ),
      value: value,
    );
  }
}

class ImageList extends StatelessWidget {
  ImageList({super.key, required this.collectionIndex});
  int collectionIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50.h),
          child: AnimationLimiter(
            child: GetBuilder<CollectionsController>(builder: (controller) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller
                    .collectionsList[collectionIndex].products!.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1500),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                          child: Align(
                        widthFactor: 0.8,
                        child: index >= 3
                            ? const SizedBox()
                            : Container(
                                height: 150.r,
                                width: 150.r,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: HexColor(controller
                                        .collectionsList[collectionIndex]
                                        .products![index]
                                        .imageColour),
                                    borderRadius: BorderRadius.circular(75.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1.5,
                                        blurRadius: 5,
                                        offset: Offset(
                                            2, 3), // changes position of shadow
                                      ),
                                    ],
                                    border: Border.all(
                                        color: AppColors.lighten(
                                            AppColors.secondary, 1),
                                        width: 2.5)),
                                child: CachedNetworkImage(
                                  imageUrl: controller
                                      .collectionsList[collectionIndex]
                                      .products![index]
                                      .images[0],
                                ),
                              ),
                      )),
                    ),
                  );
                },
              );
            }),
          ),
        ),
        Get.put(CollectionsController())
                    .collectionsList[collectionIndex]
                    .products!
                    .length >
                3
            ? Align(
                widthFactor: 0.1,
                child: Container(
                  height: 90.r,
                  width: 90.r,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(75.r)),
                  child: Center(
                    child: Text(
                      '+${Get.put(CollectionsController()).collectionsList[collectionIndex].products!.length - 3}',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat-Bold',
                          fontSize: 50.sp),
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
