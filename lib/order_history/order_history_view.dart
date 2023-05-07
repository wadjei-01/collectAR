import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/order_history/order_history_controller.dart';
import 'package:navbar/orders/orders_model.dart';
import 'package:navbar/orders/orders_view.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../theme/globals.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderHistoryController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Orders",
          style:
              BoldHeaderstextStyle(fontSize: 55.sp, color: AppColors.secondary),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.firestoreDB.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return AnimationLimiter(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Orders orders = Orders.fromJson(snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>);

                    var str = orders.orderID.split("-");
                    String id = str[1] + str[3];

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 400),
                      delay: Duration(milliseconds: 200),
                      child: SlideAnimation(
                        verticalOffset: 150.0,
                        child: FadeInAnimation(
                          child: OrdersCard(
                            orders: orders,
                            id: id,
                            onTap: () => Get.to(() => OrdersPage(),
                                arguments: orders.orderID),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                  child: Text("No order has been made yet",
                      style: BoldHeaderstextStyle(
                          fontSize: 40.sp, color: AppColors.secondary)));
            }
          } else {
            return Center(
                child: Text(
              "Error!",
              style: BoldHeaderstextStyle(
                  fontSize: 40.sp, color: AppColors.secondary),
            ));
          }
        },
      ),
    );
  }
}

class OrdersCard extends StatelessWidget {
  OrdersCard({super.key, required this.orders, required this.id, this.onTap});

  final Orders orders;
  final String id;
  dynamic onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
          child: Padding(
            padding: EdgeInsets.all(40.r),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${id}',
                        style: MediumHeaderStyle(fontSize: 40.sp),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 55.h,
                        decoration: BoxDecoration(
                            color: AppColors.lighten(
                                showColorUpdate(orders.status.name), 0.4),
                            borderRadius: BorderRadius.circular(15.r)),
                        child: IntrinsicWidth(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Ionicons.ellipse_sharp,
                                  size: 20.r,
                                  color: showColorUpdate(orders.status.name),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                Text(
                                  showTitleUpdate(orders.status.name),
                                  style: MediumHeaderStyle(
                                      fontSize: 30.sp,
                                      color: AppColors.secondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Ionicons.location,
                        color: AppColors.title,
                        size: 50.r,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        orders.userLocation,
                        style: MediumHeaderStyle(
                            color: AppColors.title, fontSize: 35.sp),
                      )
                    ],
                  ),
                  Divider(
                    color: AppColors.title,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 85.r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimationLimiter(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: orders.items.length,
                              itemBuilder: (context, value) {
                                if (value <= 6) {
                                  return AnimationConfiguration.staggeredList(
                                    position: value,
                                    duration: Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: value <= 10
                                            ? Align(
                                                widthFactor: 0.8,
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  height: 85.r,
                                                  width: 85.r,
                                                  decoration: BoxDecoration(
                                                      color: Color(orders
                                                          .items[value].color),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              45.r)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: orders
                                                        .items[value].image,
                                                    fit: BoxFit.fitWidth,
                                                    width: 70.r,
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (value + 1 == orders.items.length) {
                                    return Container(
                                      alignment: Alignment.center,
                                      height: 85.r,
                                      width: 85.r,
                                      decoration: BoxDecoration(
                                          color: AppColors.secondary,
                                          borderRadius:
                                              BorderRadius.circular(45.r)),
                                      child: Text(
                                        '+${orders.items.length - 6}',
                                        style: MediumHeaderStyle(
                                            color: Colors.white,
                                            fontSize: 30.sp),
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                }
                              }),
                        ),
                        Container(
                          height: 70.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(15.r)),
                          child: IntrinsicWidth(
                            child: Text(
                              timeago.format(orders.date.toDate()),
                              style:
                                  MediumHeaderStyle(color: AppColors.secondary),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
