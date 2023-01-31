import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navbar/collections/collections_model.dart';
import 'package:navbar/otherpages/productpage/product_controller.dart';
import 'package:navbar/widgets.dart';

class CollectionsPage extends StatelessWidget {
  CollectionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    final collection = Get.arguments as Collections;

    return Scaffold(
      appBar: CustomAppBar(
          scrollController: scrollController,
          startAppBarColor: Color(collection.color),
          targetAppBarColor: Colors.white,
          startIconColor: Colors.white,
          targetIconColor: Colors.black),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(
              height: 70.h,
            ),
            collection.products!.isEmpty
                ? Center(
                    child: Text("Nothing to show"),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30.h,
                      childAspectRatio: 2.w / 2.2.h,
                      crossAxisSpacing: 30.w,
                    ),
                    itemCount: collection.products!.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                          storedProducts: collection.products![index],
                          onPressed: () => onCardPressed(
                                collection.products![index],
                              ));
                    })
          ],
        ),
      ),
    );
  }
}
