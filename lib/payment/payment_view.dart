import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/cart_page/cartcontroller.dart';
import 'package:navbar/orders/orders_model.dart';
import 'package:navbar/orders/orders_view.dart';
import 'package:navbar/payment/payment_controller.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';
import 'package:navbar/models/user_model.dart' as userModel;
import 'package:navbar/box/boxes.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../main.dart';
import '../otherpages/globals.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    userModel.User userDets = box.get('user');
    final sController = ScrollController();
    final controller = Get.put(PaymentController());
    final cartController = Get.find<CartController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        scrollController: sController,
        startAppBarColor: Colors.white,
        targetAppBarColor: Colors.white,
        startIconColor: AppColors.secondary,
        targetIconColor: AppColors.secondary,
        sideButtonExists: false,
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r)),
                child: Padding(
                  padding: EdgeInsets.only(top: 70.h, left: 30.w, right: 30.w),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartController.box.length,
                      itemBuilder: (context, index) {
                        return orderContainer(index,
                            cartController: cartController);
                      }),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              getContainer([
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: MediumHeaderStyle(fontSize: 50.sp),
                    ),
                    Text(
                      '₵${cartController.totalCost().toStringAsFixed(2)}',
                      style: MediumHeaderStyle(fontSize: 50.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Fee',
                      style: RegularHeaderStyle(fontSize: 45.sp),
                    ),
                    Text(
                      '₵15',
                      style: RegularHeaderStyle(fontSize: 45.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax',
                      style: RegularHeaderStyle(fontSize: 45.sp),
                    ),
                    Text(
                      '₵${(cartController.totalCost() * 0.01).toStringAsFixed(2)}',
                      style: RegularHeaderStyle(fontSize: 45.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                getDivider(),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: MediumHeaderStyle(fontSize: 50.sp),
                    ),
                    Text(
                      '₵${cartController.overallCost().toStringAsFixed(2)}',
                      style: MediumHeaderStyle(fontSize: 50.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                )
              ]),
              SizedBox(
                height: 20.h,
              ),
              getContainer([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: MediumHeaderStyle(fontSize: 50.sp),
                    ),
                    Text(
                      '₵${cartController.overallCost().toStringAsFixed(2)}',
                      style: MediumHeaderStyle(fontSize: 50.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Ionicons.cash,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          'Cash',
                          style: RegularHeaderStyle(fontSize: 45.sp),
                        ),
                      ],
                    ),
                    Text(
                      '₵${cartController.overallCost().toStringAsFixed(2)}',
                      style: RegularHeaderStyle(fontSize: 45.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                SlideAction(
                  outerColor: AppColors.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Place Order",
                        style: MediumHeaderStyle(
                            color: Colors.white, fontSize: 55.sp),
                      ),
                      Text(
                        "Slide to confirm",
                        style: RegularHeaderStyle(
                            color: Colors.white, fontSize: 35.sp),
                      ),
                    ],
                  ),
                  elevation: 0,
                  onSubmit: () {
                    Future.delayed(Duration(seconds: 1), () {
                      //TODO: Add addOrdertoFB function here
                      PaymentController.addToFB();
                      cartController.box.clear();
                      cartController.update();
                      Get.off(() => OrdersPage(),
                          arguments: PaymentController.oID);
                    });
                  },
                )
              ])
            ]);
          }),
        ),
      ),
    );
  }
}
