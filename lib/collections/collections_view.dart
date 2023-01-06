import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navbar/collections/collections_controller.dart';
import 'package:navbar/collections/collections_model.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';

import '../widgets.dart';

class CollectionsView extends GetView<CollectionsController> {
  CollectionsView({super.key});
  // Product? product;

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
                                  childAspectRatio: 2.w / 2.h,
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
                                                      height: 320.h,
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
                        () {
                      if (newCollectionsController
                          .textController.text.isNotEmpty) {
                        collectionsController.newCollection(
                            newCollectionsController.textController.text,
                            newCollectionsController.screenPickerColor.value);
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
                        Row(
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
                   
