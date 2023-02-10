import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/order_history/order_history_controller.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/payment/payment_view.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';
import '../order_history/order_history_view.dart';
import 'cartcontroller.dart';
import 'cartmodel.dart';
import '../../otherpages/productpage/product_view.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartVM = Get.put(CartController());
  final orderHistoryController = Get.find<OrderHistoryController>();

  @override
  Widget build(BuildContext context) {
    orderHistoryController.checkOrderHistory();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart',
            style: BoldHeaderstextStyle(
                fontSize: 55.sp, color: AppColors.secondary)),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => OrderHistory());
            },
            icon: Badge(
                largeSize: 30.r,
                smallSize: 25.r,
                backgroundColor: AppColors.primary,
                alignment: AlignmentDirectional.topStart,
                child: Icon(Ionicons.newspaper),
                isLabelVisible: orderHistoryController.hasData.value),
            color: AppColors.secondary,
          )
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          GetBuilder<CartController>(
              init: cartVM,
              builder: (value) {
                if (value.box.isNotEmpty) {
                  return SizedBox(
                    height: 0.5.sh,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.box.length,
                        itemBuilder: (context, index) {
                          final quantity = value.box.getAt(index)!.quantity.obs;
                          final item = value.box.getAt(index)!;
                          return Dismissible(
                            key: Key(item.id),
                            background: Container(
                              color: Colors.red,
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) => value.del(index),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/gridbg.png'),
                                                fit: BoxFit.fill,
                                                opacity: 0.3),
                                            border: Border.all(
                                                color: Color(value.box
                                                    .getAt(index)!
                                                    .color)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            color: Color(
                                                value.box.getAt(index)!.color)),
                                        child: Center(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                value.box.getAt(index)!.image,
                                            width: 140.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        height: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 350.w,
                                              child: Text(
                                                value.box.getAt(index)!.name,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19,
                                                    fontFamily: 'Gotham',
                                                    color: AppColors.darken(
                                                        Color(value.box
                                                            .getAt(index)!
                                                            .color))),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 350.w,
                                              child: Text(
                                                '${value.box.getAt(index)!.id}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'Montserrat-Medium',
                                                    color: Color.fromARGB(
                                                        103, 0, 0, 0)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40.h,
                                            ),
                                            IntrinsicHeight(
                                              child: IntrinsicWidth(
                                                child: AnimatedContainer(
                                                  decoration: BoxDecoration(
                                                      color: Color(value.box
                                                              .getAt(index)!
                                                              .color)
                                                          .withAlpha(20),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r)),
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(20.r),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ItemNumberButton(
                                                                bgColor: Color(
                                                                    value
                                                                        .box
                                                                        .getAt(
                                                                            index)!
                                                                        .color),
                                                                buttonSize:
                                                                    66.r,
                                                                buttonRadius:
                                                                    33.r,
                                                                isAdd: false,
                                                                onCountChange:
                                                                    () {
                                                                  quantity
                                                                      .value--;
                                                                  value.add(
                                                                      value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .id,
                                                                      value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .image,
                                                                      value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .name,
                                                                      value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .price,
                                                                      quantity
                                                                          .value,
                                                                      Color(value
                                                                          .box
                                                                          .getAt(
                                                                              index)!
                                                                          .color));

                                                                  if (quantity
                                                                          .value ==
                                                                      0) {
                                                                    value.del(
                                                                        index);
                                                                  }
                                                                },
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5),
                                                                child: SizedBox(
                                                                  width: 30,
                                                                  child: Center(
                                                                    child: Obx(
                                                                      () => Text(
                                                                          value.box.getAt(index)!.quantity <= 9
                                                                              ? '0${quantity.value}'
                                                                              : '${quantity.value}',
                                                                          style: const TextStyle(
                                                                              fontFamily: 'Gotham',
                                                                              color: Colors.black,
                                                                              fontSize: 17)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              ItemNumberButton(
                                                                bgColor: Color(
                                                                    value
                                                                        .box
                                                                        .getAt(
                                                                            index)!
                                                                        .color),
                                                                isAdd: true,
                                                                buttonSize:
                                                                    66.r,
                                                                buttonRadius:
                                                                    33.r,
                                                                onCountChange:
                                                                    () {
                                                                  quantity
                                                                      .value++;
                                                                  value.add(
                                                                      value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .id,
                                                                      value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .image,
                                                                      value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .name,
                                                                      value.box
                                                                          .getAt(
                                                                              index)!
                                                                          .price,
                                                                      quantity
                                                                          .value,
                                                                      Color(value
                                                                          .box
                                                                          .getAt(
                                                                              index)!
                                                                          .color));
                                                                },
                                                              ),
                                                            ]),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Text(
                                      '₵ ${(value.box.getAt(index)!.price * quantity.value).toStringAsFixed(2)}',
                                      style: BoldHeaderstextStyle(
                                          color: AppColors.secondary,
                                          fontSize: 50.sp),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: AppColors.lighten(Colors.grey, 0.2),
                                  thickness: 0.5,
                                  indent: 20,
                                  endIndent: 20,
                                )
                              ],
                            ),
                          );
                        }),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/empty.svg',
                        fit: BoxFit.fitWidth,
                        width: 500.w,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Cart Empty",
                        style: BoldHeaderstextStyle(fontSize: 50.sp),
                      )
                    ],
                  ),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: GetBuilder<CartController>(builder: (controller) {
              return Visibility(
                visible: controller.totalCost() != 0,
                child: IntrinsicHeight(
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 2000),
                    child: Container(
                      width: 1.sw,
                      color: Colors.white,
                      // height: 0.35.sh,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.extend();
                              },
                              child: Column(children: [
                                SizedBox(
                                  height: 30.h,
                                ),
                                Center(
                                    child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 750),
                                  child: controller.isExtended.isTrue
                                      ? Icon(
                                          Ionicons.chevron_up,
                                          color: AppColors.primary,
                                        )
                                      : Icon(
                                          Ionicons.chevron_down,
                                          color: AppColors.secondary,
                                        ),
                                )),
                                SizedBox(
                                  height: 30.h,
                                ),
                              ]),
                            ),
                            Visibility(
                                visible: controller.isExtended.value,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 1000),
                                  height: controller.isExtended.isTrue
                                      ? 300.h
                                      : 0.h,
                                  decoration: BoxDecoration(
                                      color: AppColors.lighten(
                                          AppColors.title!, 0.5),
                                      borderRadius:
                                          BorderRadius.circular(55.r)),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50.w),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 50.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Item total',
                                                style: BoldHeaderstextStyle(
                                                    color: AppColors.lighten(
                                                        AppColors.title!, 0.1),
                                                    fontSize: 50.sp),
                                              ),
                                              Text(
                                                '₵${controller.totalCost().toStringAsFixed(2)}',
                                                style: BoldHeaderstextStyle(
                                                    color: AppColors.lighten(
                                                        AppColors.title!, 0.1),
                                                    fontSize: 50.sp),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 50.h,
                                          ),
                                          controller.totalCost() == 0
                                              ? SizedBox()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Tax',
                                                      style: BoldHeaderstextStyle(
                                                          color:
                                                              AppColors.lighten(
                                                                  AppColors
                                                                      .title!,
                                                                  0.1),
                                                          fontSize: 50.sp),
                                                    ),
                                                    Text(
                                                      "₵${(cartVM.totalCost() * 0.01).toStringAsFixed(2)}",
                                                      style: BoldHeaderstextStyle(
                                                          color:
                                                              AppColors.lighten(
                                                                  AppColors
                                                                      .title!,
                                                                  0.1),
                                                          fontSize: 50.sp),
                                                    )
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 70.h,
                                          ),
                                        ]),
                                  ),
                                )),
                            SizedBox(
                              height: 50.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 300.h,
                              decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(55.r),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/gridbg_white.png'),
                                      opacity: 0.5,
                                      fit: BoxFit.fill)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total',
                                      style: BoldHeaderstextStyle(
                                          color: Colors.white, fontSize: 40.sp),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Text(
                                      "₵${(controller.totalCost() + (controller.totalCost() * 0.01)).toStringAsFixed(2)}",
                                      style: MediumHeaderStyle(
                                          color: AppColors.lighten(
                                              AppColors.primary, 0.1),
                                          fontSize: 70.sp),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            button(
                                onTap: () {
                                  Get.to(PaymentPage());
                                },
                                height: 150.h,
                                widget: Text(
                                  "Proceed to Pay",
                                  style: MediumHeaderStyle(
                                      color: AppColors.secondary,
                                      fontSize: 40.sp),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
        ]),
      ),
    );
  }
}
