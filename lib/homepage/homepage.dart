import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:navbar/categories/categoriesview.dart';
import 'package:navbar/homepage/homepage_controller.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../theme/globals.dart';
import '../main.dart';
import '../search.dart';
import '../widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());
    ScrollController scrollController = ScrollController();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Home',
            style: BoldHeaderstextStyle(
                fontSize: 55.sp, color: AppColors.secondary),
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
              controller.carouselController.animateToPage(0);
            },
            controller: controller.refreshController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  CategoriesCarousel(),
                  SizedBox(
                    height: 20.h,
                  ),
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
                                    color: Color.fromARGB(255, 207, 207, 207),
                                    width: 150.w,
                                  ),
                                  const Text('Something went wrong')
                                ],
                              ),
                            );
                          }
                          return GridView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 45.w, vertical: 30.h),
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
                                  duration: Duration(milliseconds: 500),
                                  columnCount: 2,
                                  child: SlideAnimation(
                                    child: FadeInAnimation(
                                      child: ProductCard_2(
                                          storedProducts:
                                              controller.data[index],
                                          controller: controller,
                                          onPressed: () {
                                            displayProduct(
                                                controller.data[index]);
                                          }),
                                    ),
                                  ),
                                );
                              });
                        });
                  }),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSize(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    controller.allFetched.isTrue ? 5.h : 60.h,
                                width: double.infinity,
                              ),
                              Obx(() {
                                return Column(
                                  children: [
                                    controller.isLoading.isTrue
                                        ? LoadingIndicator()
                                        : SizedBox(
                                            height: 30.h,
                                          ),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      height: controller.allFetched.isTrue
                                          ? 0.h
                                          : 40.h,
                                      width: double.infinity,
                                    )
                                  ],
                                );
                              })
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class CategoriesCarousel extends StatelessWidget {
  const CategoriesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
            carouselController: controller.carouselController,
            itemCount: controller.imageList.length,
            itemBuilder: (context, index, realIndex) {
              final image = controller.imageList[index];
              return GestureDetector(
                onTap: () => Get.toNamed('/categories', arguments: index + 1),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Image.asset(
                    image,
                    fit: BoxFit.fitWidth,
                    width: 0.95.sw,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              viewportFraction: 0.95,
              height: 400.h,
              autoPlay: true,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                controller.activeCarourselIndex(index);
              },
            )),
        SizedBox(
          height: 10.h,
          width: 1.sw,
          child: Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.imageList.length,
              itemBuilder: (context, index) => Obx(() => AnimatedContainer(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  width: controller.activeCarourselIndex == index ? 50.w : 30.w,
                  decoration: BoxDecoration(
                      color: controller.activeCarourselIndex == index
                          ? AppColors.primary
                          : AppColors.secondary,
                      borderRadius: BorderRadius.circular(10.r)),
                  duration: Duration(milliseconds: 500))),
            ),
          ),
        ),
        SizedBox(height: 70.h),
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
