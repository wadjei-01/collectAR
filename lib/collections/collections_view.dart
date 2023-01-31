import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navbar/collections/collection_page.dart';
import 'package:navbar/collections/collections_controller.dart';
import 'package:navbar/collections/collections_model.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';

import '../box/boxes.dart';
import '../widgets.dart';

class CollectionsView extends GetView<CollectionsController> {
  CollectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionsController = Get.put(CollectionsController());
    final newCollectionsController = Get.put(NewCollectionsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.product == null ? "Collections" : "Add to Collection",
          style: TextStyle(
              color: Colors.black, fontFamily: 'Gotham Black', fontSize: 40.sp),
        ),
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
                            ? Center(child: Text("Nothing to Show"))
                            : GridView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.h,
                                  childAspectRatio: 2.w / 1.75.h,
                                  crossAxisSpacing: 10.w,
                                ),
                                itemCount: box.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: Duration(milliseconds: 750),
                                    columnCount: 2,
                                    child: SlideAnimation(
                                      child: FadeInAnimation(
                                        child: InkWell(
                                          onTap: () {
                                            if (controller.product != null) {
                                              collectionsController
                                                  .addToCollection(index,
                                                      controller.product!);
                                            } else {
                                              Get.to(CollectionsPage(),
                                                  arguments: box.get(index));
                                            }
                                          },
                                          onLongPress: () {
                                            collectionsController
                                                .deleteCollection(index);
                                            print("Deleted");
                                          },
                                          child: Container(
                                            height: 200.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.r),
                                                color: Color(
                                                    box.getAt(index)!.color),
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/gridbg.png'),
                                                    fit: BoxFit.fill,
                                                    opacity: 0.3)),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50.w),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 250.h,
                                                      child: ImageList(
                                                          collectionIndex:
                                                              index),
                                                    ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        box
                                                            .getAt(index)!
                                                            .collectionName,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 45.sp,
                                                          fontFamily:
                                                              "Montserrat-SemiBold",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Obx(() => Text(
                                                              collectionsController
                                                                  .collectionProductSize(
                                                                      index)
                                                                  .value
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      40.sp,
                                                                  fontFamily:
                                                                      'Montserrat-SemiBold'),
                                                            )),
                                                        Text(
                                                          collectionsController
                                                                      .collectionProductSize(
                                                                          index) <=
                                                                  1
                                                              ? ' Product'
                                                              : " Products",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 40.sp,
                                                              fontFamily:
                                                                  'Montserrat-SemiBold'),
                                                        ),
                                                      ],
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })));
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalBottomsheet(
                newCollectionsController, collectionsController, context)
            .whenComplete(() => newCollectionsController.reset()),
      ),
    );
  }

  Future<dynamic> modalBottomsheet(
      NewCollectionsController newCollectionsController,
      CollectionsController collectionsController,
      BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Values.borderRadius),
                topRight: Radius.circular(Values.borderRadius))),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: 800.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70.h,
                    ),
                    Text(
                      'Create Collection',
                      style: TextStyle(
                          color: AppColors.secondary,
                          fontFamily: 'Montserrat-Bold',
                          fontSize: 50.sp),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    textField(newCollectionsController.textController,
                        "Collection Name"),
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      'Pick Color',
                      style: TextStyle(
                          color: AppColors.secondary,
                          fontFamily: 'Montserrat-SemiBold',
                          fontSize: 40.sp),
                    ),
                    ColorPicker(
                        // onChangedColor: (value) {
                        //   collectionNameController.screenPickerColor = value;
                        // },
                        ),
                    SizedBox(
                      height: 40.h,
                    ),
                    button(
                        //TODO: Create method later
                        onTap: () {
                          if (newCollectionsController
                              .textController.text.isNotEmpty) {
                            collectionsController.newCollection(
                                newCollectionsController.textController.text,
                                newCollectionsController
                                    .screenPickerColor.value);
                            print(newCollectionsController.textController.text);
                            newCollectionsController.reset();
                            Navigator.pop(context);
                          } else {
                            Get.snackbar(
                              "Hi there!",
                              "The collection needs a name",
                              snackPosition: SnackPosition.TOP,
                              colorText: AppColors.secondary,
                              borderRadius: 20.r,
                              backgroundColor: AppColors.primary,
                            );
                          }
                        },
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_rounded,
                              color: AppColors.secondary,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Create",
                              style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 60.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        },
        context: context);
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
                                height: 130.r,
                                width: 130.r,
                                decoration: BoxDecoration(
                                    color: HexColor(controller
                                        .collectionsList[collectionIndex]
                                        .products![index]
                                        .imageColour),
                                    borderRadius: BorderRadius.circular(75.r)),
                                child: CachedNetworkImage(
                                    imageUrl: controller
                                        .collectionsList[collectionIndex]
                                        .products![index]
                                        .images[0]),
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
                widthFactor: 0.8,
                child: Container(
                  height: 130.r,
                  width: 130.r,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
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

class ColorPicker extends StatelessWidget {
  ColorPicker({super.key});
  final controller = Get.put(NewCollectionsController());

  @override
  Widget build(BuildContext context) {
    // controller.screenPickerColor = controller.colorList[0];

    return SizedBox(
        height: 120.h,
        width: double.infinity,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.colorList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Obx(() {
                return GestureDetector(
                  onTap: () {
                    controller.OnTap(index);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 16.w,
                    ),
                    child: Center(
                      child: Container(
                        width: 70.r,
                        height: 70.r,
                        decoration: BoxDecoration(
                            color: controller.colorList[index],
                            borderRadius: BorderRadius.circular(35.r)),
                        child: controller.selected.value == index
                            ? Center(
                                child: Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.white,
                                  size: 60.r,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                );
              });
            }));
  }
}



// InkWell(
//                         onTap: () {
//                           if (collectionNameController
//                               .textController.text.isNotEmpty) {
//                             collectionsController.newCollection(
//                                 collectionNameController.textController.text);
//                             print(collectionNameController.textController.text);
//                             collectionNameController.reset();
//                             Navigator.pop(context);
//                           }
//                         },
//                         child: Container(
//                           height: 0.06.sh,
//                           width: 0.3.sw,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30.r),
//                             color: AppColors.secondary,
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20.w),
//                             child: Center(
//                                 child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.add_circle_rounded,
//                                   color: AppColors.primary,
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   "Create",
//                                   style: TextStyle(
//                                       color: AppColors.primary,
//                                       fontSize: 60.sp,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             )),
//                           ),
//                         ),
//                       )
                   
