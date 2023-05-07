import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/order_history/order_history_controller.dart';
import 'package:navbar/payment/payment_view.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';
import '../theme/globals.dart';
import '../order_history/order_history_view.dart';
import '../productpage/product_view.dart';
import 'cartcontroller.dart';
import 'cartmodel.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartVM = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
            icon: GetBuilder<OrderHistoryController>(
                builder: (orderHistoryController) {
              orderHistoryController.checkOrderHistory();

              return Badge(
                  largeSize: 30.r,
                  smallSize: 25.r,
                  backgroundColor: AppColors.primary,
                  alignment: AlignmentDirectional.topStart,
                  child: Icon(Ionicons.newspaper),
                  isLabelVisible: orderHistoryController.hasData.value);
            }),
            color: AppColors.secondary,
          )
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          GetBuilder<CartController>(
              init: cartVM,
              builder: (value) {
                if (value.cartBox.isNotEmpty) {
                  return SizedBox(
                    height: 0.65.sh,
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 150.h),
                        shrinkWrap: true,
                        itemCount: value.getItemNum(),
                        itemBuilder: (context, index) {
                          final quantity =
                              value.cartBox.getAt(index)!.quantity.obs;
                          final item = value.cartBox.getAt(index)!;
                          return Dismissible(
                            key: Key(item.id),
                            background: Container(
                              margin: EdgeInsets.all(20.r),
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
                            onDismissed: (direction) =>
                                value.deleteProductFromCart(index),
                            child: Container(
                              margin: EdgeInsets.all(20.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1.5,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Container(
                                          height: 200.r,
                                          width: 200.r,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/gridbg.png'),
                                                  fit: BoxFit.fill,
                                                  opacity: 0.3),
                                              border: Border.all(
                                                  color: Color(value.cartBox
                                                      .getAt(index)!
                                                      .color)),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              color: Color(value.cartBox
                                                  .getAt(index)!
                                                  .color)),
                                          child: Center(
                                            child: CachedNetworkImage(
                                              imageUrl: value.cartBox
                                                  .getAt(index)!
                                                  .image,
                                              width: 140.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                      midSection(value, index, quantity),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      SizedBox(
                                        width: 300.w,
                                        child: Text(
                                          '₵  ${(value.cartBox.getAt(index)!.price * quantity.value).toStringAsFixed(2)}',
                                          style: BoldHeaderstextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 45.sp),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                visible: controller.cartBox.isNotEmpty,
                child: IntrinsicHeight(
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 2000),
                    child: Container(
                      width: 1.sw,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset:
                                Offset(0, -15), // changes position of shadow
                          ),
                        ],
                      ),
                      // height: 0.35.sh,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                      "₵${controller.getOverallCost()}",
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

  Padding midSection(CartController value, int index, RxInt quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350.w,
              child: Text(
                value.cartBox.getAt(index)!.name,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    fontSize: 45.sp,
                    fontFamily: 'Gotham',
                    color: AppColors.darken(
                        Color(value.cartBox.getAt(index)!.color))),
              ),
            ),
            SizedBox(
              width: 350.w,
              child: Text(
                '${value.cartBox.getAt(index)!.id}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: 'Montserrat-Medium',
                    color: Color.fromARGB(103, 0, 0, 0)),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            quantityButtons(value, index, quantity),
          ],
        ),
      ),
    );
  }

  IntrinsicHeight quantityButtons(
      CartController value, int index, RxInt quantity) {
    return IntrinsicHeight(
      child: IntrinsicWidth(
        child: AnimatedContainer(
          decoration: BoxDecoration(
              color: Color(value.cartBox.getAt(index)!.color).withAlpha(20),
              borderRadius: BorderRadius.circular(15.r)),
          duration: Duration(milliseconds: 500),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  AdjustQuantityButton(
                    bgColor: Color(value.cartBox.getAt(index)!.color),
                    buttonSize: 50.r,
                    buttonRadius: 25.r,
                    isAdd: false,
                    onCountChange: () =>
                        value.decreaseQuantity(index, quantity),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: 30,
                      child: Center(
                        child: Obx(
                          () => Text(
                              value.cartBox.getAt(index)!.quantity <= 9
                                  ? '0${quantity.value}'
                                  : '${quantity.value}',
                              style: TextStyle(
                                  fontFamily: 'Gotham',
                                  color: Colors.black,
                                  fontSize: 35.sp)),
                        ),
                      ),
                    ),
                  ),
                  AdjustQuantityButton(
                    bgColor: Color(value.cartBox.getAt(index)!.color),
                    isAdd: true,
                    buttonSize: 50.r,
                    buttonRadius: 25.r,
                    onCountChange: () =>
                        value.increaseQuantity(index, quantity),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
