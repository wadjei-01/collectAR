import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:navbar/categories/categoriescontroller.dart';
import 'package:navbar/widgets.dart';

import '../otherpages/globals.dart';
import '../otherpages/productpage/product_model.dart';
import '../theme/fonts.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.category,
            style: BoldHeaderstextStyle(
                fontSize: 55.sp, color: AppColors.secondary)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.categoryStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.length == 0
                ? Center(
                    child: Text("Nothing Here Yet"),
                  )
                : AnimationLimiter(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 20.w),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 30.h,
                        childAspectRatio: 2.w / 2.2.h,
                        crossAxisSpacing: 30.w,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Product product = Product.fromJson(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: Duration(milliseconds: 500),
                          columnCount: 2,
                          child: FadeInAnimation(
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: ProductCard(
                                  storedProducts: product,
                                  onPressed: () {
                                    onCardPressed(product);
                                  }),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          } else if (snapshot.hasError) {
            return Center(child: Text("Errrorrrrrr!"));
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primary,
            ));
          }
        },
      ),
    );
  }
}
