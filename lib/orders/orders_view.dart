import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:navbar/cart_page/cart_page.dart';
import 'package:navbar/firebase/firebaseDB.dart';
import 'package:navbar/orders/orders_model.dart';
import 'package:navbar/theme/fonts.dart';

import '../theme/globals.dart';
import '../widgets.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    String orderID = Get.arguments as String;
    var str = orderID.split("-");
    String id = "#${str[1]}${str[3]}";
    List<Status> stats = [
      Status.pending,
      Status.accepted,
      Status.onRoute,
      Status.delivered,
      Status.declined
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.h),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: AppColors.secondary,
          title: Text(
            id,
            style: BoldHeaderstextStyle(
                color: AppColors.secondary, fontSize: 55.sp),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          elevation: 0,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FireStoreDB.firebaseFirestore
            .collection('orders')
            .where("orderID", isEqualTo: orderID)
            .snapshots(),
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
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Orders order = Orders.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return SizedBox(
                  height: 1.sh,
                  child: Stack(children: [
                    DraggableScrollableSheet(
                      minChildSize: 0.38,
                      maxChildSize: 0.45,
                      initialChildSize: 0.38,
                      snap: true,
                      snapSizes: [0.38],
                      builder: (context, scrollController) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 750),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.r),
                                  topRight: Radius.circular(30.r))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 90.w),
                            child: ListView(
                                shrinkWrap: true,
                                controller: scrollController,
                                children: [
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Center(
                                    child: SvgPicture.asset(
                                      'assets/images/icons/dash_line.svg',
                                      fit: BoxFit.fitWidth,
                                      width: 150.w,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60.h,
                                    child: Center(
                                      child: orderProgress(stats, order),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  Center(
                                    child: Container(
                                      height: 170.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                          color: AppColors.background),
                                      child: Padding(
                                        padding: EdgeInsets.all(35.r),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 100.r,
                                              width: 100.r,
                                              child: Lottie.asset(
                                                  'assets/images/blinking.json'),
                                            ),
                                            SizedBox(
                                              width: 50.w,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  showTitleUpdate(
                                                      order.status.name),
                                                  style: MediumHeaderStyle(
                                                      fontSize: 40.sp),
                                                ),
                                                Text(
                                                  showSubtitleUpdate(
                                                      order.status.name),
                                                  style: RegularHeaderStyle(
                                                      fontSize: 35.sp,
                                                      color: AppColors.title),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                  Text(
                                    'Address',
                                    style: MediumHeaderStyle(fontSize: 45.sp),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Text(
                                    order.userLocation,
                                    style: RegularHeaderStyle(fontSize: 40.sp),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style:
                                            MediumHeaderStyle(fontSize: 45.sp),
                                      ),
                                      Text(
                                        '₵${order.total.toStringAsFixed(2)}',
                                        style:
                                            MediumHeaderStyle(fontSize: 45.sp),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                ]),
                          ),
                        );
                      },
                    ),
                  ]),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  ListView orderProgress(List<Status> stats, Orders order) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
            left: index == 0 ? 0.w : 30.w,
            right: index == 3 ? 0.w : 30.w),
        child: AnimatedContainer(
            width: 170.w,
            height: 50.h,
            decoration: BoxDecoration(
                color: showUpdate(stats, order.status.name, index),
                borderRadius: BorderRadius.circular(30.r)),
            duration: Duration(milliseconds: 500)),
      ),
    );
  }
}
