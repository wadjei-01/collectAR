import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/cart_page/cart_page.dart';
import 'package:navbar/otherpages/globals.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(CartPage());
                },
                icon: Icon(
                  Ionicons.cart,
                  color: AppColors.secondary,
                ))
          ],
        ),
      ),
    );
  }
}
