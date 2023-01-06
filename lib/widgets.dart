import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navbar/otherpages/arsession.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';

import 'otherpages/globals.dart';
import 'otherpages/productpage/product_controller.dart';
import 'otherpages/productpage/product_view.dart';

class CustomExpansionTile extends StatefulWidget {
  CustomExpansionTile({super.key, required this.title, required this.text});

  String title;
  String text;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 43.sp,
                      color: Colors.black,
                      fontFamily: 'Montserrat-SemiBold'),
                ),
                isExpanded
                    ? Icon(Icons.keyboard_arrow_down_rounded)
                    : Icon(Icons.keyboard_arrow_up_rounded)
              ],
            ),
          ),
          AnimatedContainer(
              // height: isExpanded ? 200.h : 0.h,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeIn,
              child: isExpanded
                  ? SizedBox()
                  : Text(
                      widget.text,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 3,
                      style: Values.smallText,
                    )),
          Divider(
            color: Colors.grey,
            thickness: 1.sp,
          )
        ],
      ),
    );
  }
}

class Scroller {
  static ScrollController scrollController = ScrollController();

  static void scrollDown() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  static void scrollUp() {
    scrollController.animateTo(300,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    required this.scrollController,
    required this.startAppBarColor,
    required this.targetAppBarColor,
    required this.startIconColor,
    required this.targetIconColor,
    this.backArrow,
    this.sideButton,
    this.sideBtnBoolean,
    this.sideBtnNewColor,
    this.boolValueCallback,
    this.product,
  }) : super(key: key);
  ScrollController scrollController;
  Color startAppBarColor;
  // Color.fromARGB(0, 255, 255, 255);
  Color targetAppBarColor;
  //  Colors.white;

  Color startIconColor;
  //  = Color(0xFFF4F5FD);
  Color targetIconColor;
  //  = AppColor.black;

  IconData? backArrow;
  IconData? sideButton;
  bool? sideBtnBoolean;
  Function(bool)? boolValueCallback;
  Color? sideBtnNewColor;
  Product? product;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  double lerp = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(listener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(listener);
    super.dispose();
  }

  void listener() {
    var offset = widget.scrollController.offset;
    setState(() => lerp = offset < 750.h ? offset / 750.h : 1);
    // print(lerp);
  }

  //
  ColorTween get appBarColorTween =>
      ColorTween(begin: widget.startAppBarColor, end: widget.targetAppBarColor);
  ColorTween get iconColorTween =>
      ColorTween(begin: widget.startIconColor, end: widget.targetIconColor);

  Color get appBarColor =>
      appBarColorTween.transform(lerp) ?? widget.startAppBarColor;
  Color get iconColor =>
      iconColorTween.transform(lerp) ?? widget.startIconColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: appBarColor,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () {
              Get.delete<ProductController>();
              Get.back();
            },
            child: Container(
              width: 150.w,
              height: 95.h,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: iconColor,
                  size: 60.r,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(ARSession(product: widget.product));
            },
            child: Container(
              width: 150.r,
              height: 150.r,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(45.r)),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/icons/ar_cube.svg',
                  width: 90.r,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ]),
      ),
      titleSpacing: 0,
    );
  }
}

TextFormField textField(TextEditingController textController, [String? hint]) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    controller: textController,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 213, 213, 213)),
          borderRadius: BorderRadius.circular(20.r)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(20.r)),
      hintText: hint,
      contentPadding: EdgeInsets.only(left: 40.w),
      border: InputBorder.none,
    ),
  );
}

InkWell button(
    [dynamic onTap, Widget? widget, Color? containerColor, Color? textColor]) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          color: containerColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(20.r)),
      child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 36.h), child: widget)),
    ),
  );
}

class CustomCarouselSlider extends StatefulWidget {
  CustomCarouselSlider({
    Key? key,
    this.initialPage,
    this.selectedColor,
    this.unselectedColor,
    this.duration,
    required this.imageContainerList,
    required this.height,
    required this.indicatorTop,
  }) : super(key: key);
  List<Widget>? imageContainerList;
  int? initialPage;
  //272.h
  double height;
  //250.h
  double indicatorTop;

  Color? selectedColor;
  Color? unselectedColor;
  Duration? duration;

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  PageController pageController = PageController();
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    pageController = PageController(
      initialPage: widget.initialPage ?? 0,
    );
    print(widget.imageContainerList!.length);
    return Scaffold(
      body: SizedBox(
        height: widget.height,
        child: Stack(children: [
          PageView.builder(
              onPageChanged: (value) => setState(() {
                    currentImageIndex = value;
                  }),
              controller: pageController,
              itemCount: widget.imageContainerList!.length,
              itemBuilder: (context, index) {
                return imageSlider(index, widget.height);
              }),
          Positioned(
            bottom: widget.height / 120.h,
            child: CarouselIndicator(
                totalSteps: widget.imageContainerList!.length,
                currentSteps: currentImageIndex,
                selectedColor: widget.selectedColor ?? Colors.white,
                unselectedColor:
                    widget.unselectedColor ?? Colors.white.withOpacity(0.5),
                duration: widget.duration ?? Duration(milliseconds: 500)),
          )
        ]),
      ),
    );
  }

  Widget imageSlider(int index, double height) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, widget) {
        return Center(
          child: Container(
            height: height,
            child: widget,
          ),
        );
      },
      child: widget.imageContainerList![index],
    );
  }
}

class CarouselIndicator extends StatelessWidget {
  CarouselIndicator({
    Key? key,
    required this.totalSteps,
    required this.currentSteps,
    required this.selectedColor,
    required this.unselectedColor,
    required this.duration,
  }) : super(key: key);

  final int totalSteps;
  final int currentSteps;
  final Color selectedColor;
  final Color unselectedColor;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 70.h,
        width: 1.sw,
        child: MediaQuery.removePadding(
          removeLeft: true,
          removeRight: true,
          context: context,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: totalSteps,
              itemBuilder: (context, index) {
                return getStepper1(index);
              }),
        ));
  }

  Padding getStepper1(int index) {
    return Padding(
      padding: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 5),
      child: Column(
        children: [
          AnimatedContainer(
            width: currentSteps == index ? 45.w : 15.w,
            height: 15.h,
            decoration: BoxDecoration(
                color: currentSteps == index ? selectedColor : unselectedColor,
                borderRadius: BorderRadius.circular(10)),
            duration: duration,
          ),
        ],
      ),
    );
  }
}

onCardPressed(Product data, ProductController controller) {
  try {
    Get.to(() => const ProductScreen(),
        preventDuplicates: false,
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 550),
        arguments: data,
        transition: Transition.fadeIn);
    controller.getData(data);
    controller.refresh();
  } on RangeError catch (value) {
    print(value.message);
  }
}

class ProductCard extends StatelessWidget {
  ProductCard(
      {Key? key,
      required this.storedProducts,
      required this.onPressed,
      this.size})
      : super(key: key);

  Product storedProducts;
  final void Function() onPressed;
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
            SizedBox(
              height: 70.h,
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
                        height: 230.h,
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
                    storedProducts.price,
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
