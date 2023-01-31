import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:navbar/collections/collections_view.dart';
import 'package:navbar/main.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';
import 'package:navbar/otherpages/arsession.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/models/user_model.dart' as userModels;
import 'package:navbar/otherpages/productpage/product_controller.dart';
import 'package:navbar/widgets.dart';
import '../../collections/collections_controller.dart';
import '../../homepage/homepage.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});
  // final Product product;

  final controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final bgColor = HexColor(controller.product.imageColour);

    ScrollController sController = ScrollController();

    List<Widget>? listBanners;

    listBanners = List.generate(
        controller.product.images.length - 1,
        (index) => Container(
              width: 1.sw,
              child: CachedNetworkImage(
                imageUrl: controller.product.images[index + 1],
                progressIndicatorBuilder: (context, url, progress) => Center(
                    child: LoadingIndicator(progress: progress.progress)),
                fit: BoxFit.fitWidth,
              ),
            ));

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          startAppBarColor: Colors.white,
          targetAppBarColor: bgColor,
          targetIconColor: Colors.white,
          startIconColor: bgColor,
          scrollController: sController,
          product: controller.product,
        ),
        body: SingleChildScrollView(
          controller: sController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 230.h),
              SizedBox(
                height: 1000.h,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Values.borderRadius),
                      bottomRight: Radius.circular(Values.borderRadius)),
                  child: CustomCarouselSlider(
                    height: 1000.h,
                    imageContainerList: listBanners,
                    indicatorTop: 780.h,
                  ),
                ),
              ),
              SizedBox(
                height: 70.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.product.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Monserrat-Medium',
                                        fontSize: 60.sp,
                                        color: bgColor),
                                  ),
                                ]),
                            GestureDetector(
                              onTap: () =>
                                  // collectionsController.openDialog(context, store)
                                  Get.to(CollectionsView(),
                                      arguments: controller.product),
                              child: Container(
                                width: 120.r,
                                height: 95.r,
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(20.r)),
                                child: Padding(
                                  padding: EdgeInsets.all(15.r),
                                  child: Center(
                                    child: SizedBox(
                                      child: SvgPicture.asset(
                                          'assets/images/icons/collections icon.svg'),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          controller.product.category,
                          style: TextStyle(
                              color: AppColors.title,
                              fontFamily: 'Monserrat-Medium',
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Text(
                          controller.product.description,
                          style: Values.smallText,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1.sp,
                        ),
                        GetBuilder<ProductController>(builder: (control) {
                          return CustomExpansionTile(
                              title: "Product Details",
                              text: controller.product.details);
                        }),
                        GetBuilder<ProductController>(builder: (control) {
                          return CustomExpansionTile(
                              title: "Measurements",
                              text: controller.product.description);
                        }),
                        SizedBox(
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    return Obx(() {
                      return StreamBuilder(
                          stream: controller.relatedProducts.snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              // print(snapshot.data!.docs.length);
                              return snapshot.data!.docs.isEmpty
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 45.w),
                                          child: Text("Related Products",
                                              style: TextStyle(
                                                  fontSize: 43.sp,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'Montserrat-SemiBold')),
                                        ),
                                        SizedBox(
                                          height: 50.h,
                                        ),
                                        SizedBox(
                                          height: 500.h,
                                          width: 1.sw,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final DocumentSnapshot
                                                    documentSnapshot =
                                                    snapshot.data!.docs[index];

                                                Product product =
                                                    Product.fromJson(
                                                  documentSnapshot.data()
                                                      as Map<String, dynamic>,
                                                );
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                        left: index == 0
                                                            ? 120.w
                                                            : 30.w,
                                                        right: index ==
                                                                snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length -
                                                                    1
                                                            ? 60.w
                                                            : 0.w),
                                                    child: ProductCard(
                                                        storedProducts: product,
                                                        onPressed: () {
                                                          onCardPressed(
                                                              product);
                                                          controller.update();
                                                        }));
                                              }),
                                        ),
                                      ],
                                    );
                            } else {
                              return CircularProgressIndicator();
                            }
                          });
                    });
                  }),
                  SizedBox(
                    height: 500.h,
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.lighten(bgColor, 0.5),
            // borderRadius: BorderRadius.circular(35.r)
          ),
          height: 300.h,
          child: Padding(
            padding: EdgeInsets.only(left: 40.w, right: 40.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 300.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                      color: AppColors.lighten(
                          HexColor(controller.product.imageColour), 0.4),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ItemNumberButton(
                          bgColor: bgColor,
                          isAdd: false,
                          onCountChange: controller.decrement
                          // controller.quantity.value--;
                          ,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SizedBox(
                            width: 80.w,
                            child: Center(
                              child: Obx(
                                () => Text(
                                    controller.quantity.value <= 9
                                        ? '0${controller.quantity.value.toString()}'
                                        : '${controller.quantity.value.toString()}',
                                    style: TextStyle(
                                        fontFamily: 'Gotham Black',
                                        color: Colors.black,
                                        fontSize: 35.sp)),
                              ),
                            ),
                          ),
                        ),
                        ItemNumberButton(
                          bgColor: bgColor,
                          isAdd: true,
                          onCountChange: controller.increment
                          // controller.quantity.value++;
                          // print(controller.quantity);
                          ,
                        ),
                      ]),
                ),
                Obx(() {
                  return controller.isAdded.value == true
                      ? ElevatedButton(
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: "Item is already added to cart",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.r))),
                              elevation: 0,
                              primary: Colors.grey,
                              fixedSize: Size(650.w, 150.h)),
                          child: const Text('Added',
                              style: TextStyle(
                                  fontFamily: 'Gotham Book',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700)),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            // addtoStoreCart();
                            controller.cart.add(
                                controller.product.id,
                                controller.product.images[0],
                                controller.product.name,
                                controller.product.price,
                                controller.quantity.value,
                                bgColor);
                            controller.checkProduct();
                            Fluttertoast.showToast(
                              msg: "Added to cart",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.r))),
                              elevation: 0,
                              primary: bgColor,
                              fixedSize: Size(650.w, 150.h)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '₵ ${controller.product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 45.sp,
                                    fontFamily: 'Montserrat-Bold',
                                    color: Colors.white),
                              ),
                              Text(' | ',
                                  style: TextStyle(
                                    fontFamily: 'Gotham Black',
                                    fontSize: 70.sp,
                                  )),
                              SizedBox(
                                height: 58.1.r,
                                width: 70.r,
                                child: SvgPicture.asset(
                                  'assets/images/icons/cart.svg',
                                  fit: BoxFit.fill,
                                ),
                              )
                            ],
                          ),
                        );
                })
              ],
            ),
          ),
        ));
  }
}

// class ProductScreen extends StatefulWidget {
//   ProductScreen({Key? key, required this.store}) : super(key: key);
//   final Store store;

//   @override
//   State<ProductScreen> createState() => _ProductScreenState();
// }

// class _ProductScreenState extends State<ProductScreen> {
//   userModels.User user = box.get('user');

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = HexColor(widget.store.imageColour);
//     Size size = MediaQuery.of(context).size;
//     final controller = Get.put(ProductController(widget.store));

//     return }
// }

class ItemNumberButton extends StatefulWidget {
  ItemNumberButton(
      {Key? key,
      required this.onCountChange,
      required this.isAdd,
      this.buttonSize,
      this.buttonRadius,
      required this.bgColor})
      : super(key: key);

  final bool isAdd;
  final double? buttonSize;
  final double? buttonRadius;
  final void Function() onCountChange;
  final Color bgColor;

  @override
  State<ItemNumberButton> createState() => _ItemNumberButtonState();
}

class _ItemNumberButtonState extends State<ItemNumberButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onCountChange,
      onLongPress: widget.onCountChange,
      child: Container(
        height: widget.buttonSize ?? 90.r,
        width: widget.buttonSize ?? 90.r,
        decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(widget.buttonRadius ?? 45.r)),
        child: Center(
          child: Icon(
            widget.isAdd ? Icons.add : Icons.remove,
            color: Colors.white,
            size: 10,
          ),
        ),
      ),
    );
  }
}
