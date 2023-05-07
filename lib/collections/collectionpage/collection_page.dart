import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/collections/collectionpage/collection_controller.dart';
import 'package:navbar/collections/collections_controller.dart';
import 'package:navbar/collections/collections_model.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';
import 'package:hive/hive.dart';
import '../../box/boxes.dart';
import '../../productpage/product_model.dart';
import '../../theme/globals.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({super.key, required this.collectionIndex});
  int collectionIndex;
  final controller = Get.put(CollectionController());

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  void initState() {
    widget.controller.assignCollection(widget.collectionIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: CustomAppBar(
          scrollController: scrollController,
          startAppBarColor: Colors.white,
          targetAppBarColor: Color(widget.controller.collection!.color),
          startIconColor: Color(widget.controller.collection!.color),
          targetIconColor: Colors.white,
          sideButtonExists: true,
          product: widget.controller.collection!.products,
          title: widget.controller.collection!.collectionName),
      body: Column(
        children: [
          widget.controller.collection!.products!.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      "Nothing to show",
                      style: BoldHeaderstextStyle(
                          color: AppColors.secondary, fontSize: 40.sp),
                    ),
                  ),
                )
              : Expanded(
                  child: ValueListenableBuilder<Box<Collections>>(
                      valueListenable: Boxes.getCollections().listenable(),
                      builder: (context, box, _) {
                        return GridView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 50.h, horizontal: 30.w),
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 30.h,
                              childAspectRatio: 2.w / 2.2.h,
                              crossAxisSpacing: 30.w,
                            ),
                            itemCount: box
                                .getAt(widget.collectionIndex)!
                                .products!
                                .length,
                            itemBuilder: (context, index) {
                              return CollectionCard(
                                  storedProducts: box
                                      .getAt(widget.collectionIndex)!
                                      .products![index],
                                  onPressed: () => displayProduct(
                                        box
                                            .getAt(widget.collectionIndex)!
                                            .products![index],
                                      ),
                                  delete: () {
                                    box
                                        .getAt(widget.collectionIndex)!
                                        .products!
                                        .removeAt(index);
                                    Get.find<CollectionsController>().update();
                                    setState(() {});
                                  });
                            });
                      }),
                )
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: widget.controller.addCollectionToCart,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 100.r),
          width: 400.w,
          height: 125.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(50.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2.5,
                blurRadius: 5,
                offset: Offset(1, 3), // changes position of shadow
              ),
            ],
          ),
          child: Text(
            'Add to Cart (${widget.controller.collection!.products?.length})',
            style: BoldHeaderstextStyle(
                color: AppColors.secondary, fontSize: 35.sp),
          ),
        ),
      ),
    );
  }
}

class CollectionCard extends StatelessWidget {
  CollectionCard(
      {Key? key,
      required this.storedProducts,
      required this.onPressed,
      required this.delete,
      this.size})
      : super(key: key);

  Product storedProducts;
  final void Function() onPressed;
  final void Function() delete;
  Size? size;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    Color textColor =
        color.computeLuminance() < 0.6 ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size?.width ?? 400.w,
        height: size?.height ?? 500.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: HexColor(storedProducts.imageColour),
            image: DecorationImage(
                image: AssetImage('assets/images/gridbg.png'),
                fit: BoxFit.fill,
                opacity: 0.3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 70.h,
                ),
                IconButton(
                  onPressed: delete,
                  icon: Icon(Ionicons.close),
                  color: Colors.white,
                ),
              ],
            ),
            TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.easeInOut,
                duration: const Duration(seconds: 1),
                builder: ((context, double opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: storedProducts.images[0],
                        height: 250.h,
                      ),
                    ),
                  );
                })),
            SizedBox(
              height: 60.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 50.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storedProducts.name,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'Gotham Book',
                        fontSize: 12,
                        color: textColor,
                        overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    '₵ ${storedProducts.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontFamily: 'Montserrat Black',
                        fontSize: 13,
                        color: textColor),
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
