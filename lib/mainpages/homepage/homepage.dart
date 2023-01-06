import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:navbar/mainpages/homepage/homepage_controller.dart';
import 'package:navbar/otherpages/category_selection_page.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/otherpages/productpage/product_controller.dart';
import 'package:navbar/otherpages/productpage/product_view.dart';
import 'package:navbar/otherpages/search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../main.dart';
import '../../otherpages/productpage/product_model.dart';
import '../../widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());
    ScrollController scrollController = ScrollController();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '',
            style: TextStyle(color: Colors.black, fontFamily: 'Gotham Black'),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black,
                onPressed: () {
                  showSearch(context: context, delegate: Search());
                },
              ),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            return controller.nextPage(scrollEnd);
          },
          child: SmartRefresher(
            onRefresh: () {
              controller.reset();
            },
            controller: controller.refreshController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Builder(builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Categories(),
                    SizedBox(
                      height: 40.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.w),
                      child:
                          GetBuilder<HomePageController>(builder: (controller) {
                        return StreamBuilder<Object>(
                            stream: controller.query.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/icons/error.svg',
                                        color:
                                            Color.fromARGB(255, 207, 207, 207),
                                        width: 150.w,
                                      ),
                                      const Text('Something went wrong')
                                    ],
                                  ),
                                );
                              }
                              return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 30.h,
                                    childAspectRatio: 2.w / 2.2.h,
                                    crossAxisSpacing: 30.w,
                                  ),
                                  itemCount: controller.data.length,
                                  itemBuilder: (_, index) {
                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration: Duration(milliseconds: 750),
                                      columnCount: 2,
                                      child: SlideAnimation(
                                        child: FadeInAnimation(
                                          child: ProductCard(
                                              storedProducts:
                                                  controller.data[index],
                                              onPressed: () {
                                                onCardPressed(
                                                    controller.data[index],
                                                    ProductController());
                                              }),
                                        ),
                                      ),
                                    );
                                  });
                            });
                      }),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSize(
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: controller.allFetched ? 15.h : 30.h,
                                  width: double.infinity,
                                ),
                                controller.isLoading
                                    ? SizedBox(
                                        height: 70.r,
                                        width: 70.r,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : SizedBox(
                                        height: 30.h,
                                      ),
                                SizedBox(
                                  height: controller.allFetched ? 15.h : 50.h,
                                  width: double.infinity,
                                )
                              ],
                            )),
                      ],
                    )
                  ],
                );
              }),
            ),
          ),
        ));
  }
}

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<HomePageController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 45.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Our',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text('Products',
                      style:
                          TextStyle(fontSize: 30, fontFamily: 'Gotham Black'))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 45.w),
              child: GestureDetector(
                child: Container(
                  height: 100.h,
                  width: 275.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(color: Colors.black, width: 3.r),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text('Categories',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gotham Black',
                            fontSize: 30.sp)),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategorySelectionPage()));
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 90.h),
        SizedBox(
          height: 120.h,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 75.w,
                ),
                GetBuilder<HomePageController>(builder: (controller) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.tabs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => controller.switchCategory(index),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: controller.selected == index
                                ? AppColors.primary
                                : Color.fromARGB(255, 238, 238, 238),
                          ),
                          height: 5,
                          width: (controller.tabs[index].toString().length +
                              270.w),
                          child: Center(
                              child: Text(
                            controller.tabs[index],
                            style: TextStyle(
                                fontSize: 35.sp,
                                color: controller.selected == index
                                    ? Colors.black
                                    : Color.fromARGB(255, 179, 179, 179),
                                fontFamily: controller.selected == index
                                    ? 'Montserrat-Bold'
                                    : 'Montserrat'),
                          )),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        )
      ],
    );
  }
}
