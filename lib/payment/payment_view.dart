import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navbar/cart_page/cartcontroller.dart';
import 'package:navbar/payment/payment_controller.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';
import 'package:navbar/models/user_model.dart' as userModel;
import 'package:navbar/box/boxes.dart';

import '../main.dart';
import '../otherpages/globals.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    userModel.User userDets = box.get('user');
    final sController = ScrollController();
    final controller = Get.put(PaymentController());
    final cartContoller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 237, 239),
      appBar: CustomAppBar(
        scrollController: sController,
        startAppBarColor: Colors.white,
        targetAppBarColor: Colors.white,
        startIconColor: AppColors.secondary,
        targetIconColor: AppColors.secondary,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(children: [
              SizedBox(
                height: 30.h,
              ),
              AnimatedSize(
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.topCenter,
                duration: Duration(milliseconds: 500),
                reverseDuration: Duration(milliseconds: 500),
                child: GestureDetector(
                  onTap: () => controller.extend(),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: controller.isExtended.isTrue ? 500.h : 230.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.lighten(AppColors.primary, 0.1),
                        borderRadius: BorderRadius.circular(30.r)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "Location",
                            style: BoldHeaderstextStyle(
                                color: AppColors.secondary, fontSize: 40.sp),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            userDets.location,
                            style: MediumHeaderStyle(
                                color: AppColors.secondary, fontSize: 50.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartContoller.box.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.h),
                      child: Container(
                        height: 200.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Container(
                                height: 140.r,
                                width: 140.r,
                                decoration: BoxDecoration(
                                    color: Color(
                                      cartContoller.box.getAt(index)!.color,
                                    ),
                                    borderRadius: BorderRadius.circular(70.r)),
                                child: CachedNetworkImage(
                                    imageUrl:
                                        cartContoller.box.getAt(index)!.image),
                              ),
                              SizedBox(
                                width: 30.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 500.w,
                                      child: Text(
                                        cartContoller.box.getAt(index)!.name,
                                        style: MediumHeaderStyle(
                                            color: Color(cartContoller.box
                                                .getAt(index)!
                                                .color),
                                            fontSize: 40.sp,
                                            overFlow: TextOverflow.ellipsis),
                                      )),
                                  SizedBox(
                                      width: 500.w,
                                      child: Text(
                                        cartContoller.box.getAt(index)!.id,
                                        style: RegularHeaderStyle(
                                          fontSize: 35.sp,
                                        ),
                                      )),
                                ],
                              ),
                              Text(cartContoller.box
                                  .getAt(index)!
                                  .price
                                  .toStringAsFixed(2))
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ]);
          }),
        ),
      ),
    );
  }
}
