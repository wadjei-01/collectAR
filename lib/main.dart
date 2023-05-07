import 'dart:async';
import 'dart:math';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:badges/badges.dart' as badge;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/categories/categoriesview.dart';
import 'package:navbar/collections/collectionpage/collection_page.dart';
import 'package:navbar/collections/collections_model.dart';
import 'package:navbar/collections/collections_view.dart';
import 'package:navbar/homepage/homepage.dart';
import 'package:navbar/arsession/arsession.dart';
import 'package:navbar/productpage/product_bindings.dart';
import 'package:navbar/productpage/product_model.dart';
import 'package:navbar/productpage/product_view.dart';
import 'package:navbar/settings/settings_page.dart';
import 'package:navbar/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar/theme/fonts.dart';
import 'package:navbar/widgets.dart';
import 'auth/rootpage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
// import 'package:badges/src/badge.dart';
import 'package:flutter/services.dart';
import 'package:navbar/models/user_model.dart' as userModel;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'box/boxes.dart';
import 'cart_page/cart_page.dart';
import 'cart_page/cartcontroller.dart';
import 'cart_page/cartmodel.dart';
import 'categories/categories_binding.dart';
import 'collections/collections_controller.dart';
import 'collections/newcollectioncontroller.dart';
import 'theme/globals.dart';
import 'models/user_model.dart';
import 'order_history/order_history_controller.dart';
import 'orders/orders_view.dart';
import 'arsession/arsessionbinding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CollectionsAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartModelAdapter());
  Hive.registerAdapter(TimestampAdapter());
  await Hive.openBox<userModel.User>('user');
  await Hive.openBox<Collections>('collections');
  await Hive.openBox<CartModel>('cart');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,

    //color set to transparent or set your own color
    statusBarIconBrightness: Brightness.dark,
    //set brightness for icons, like dark background light icons
  )); // transparent status bar
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAppController());
    return ScreenUtilInit(
        designSize: const Size(1080, 2340),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: MyTheme.lightV2,
            scrollBehavior: ScrollBehavior(
                androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
            initialRoute: '/',
            getPages: [
              GetPage(
                name: '/',
                page: () => AnimatedSplashScreen(
                    splashIconSize: 1.sh,
                    duration: controller.time * 1000,
                    splash: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 450.h,
                          ),
                          Center(
                            child: IntrinsicWidth(
                              child: Image(
                                image: svg.Svg(
                                    'assets/images/collectAR (text).svg'),
                                fit: BoxFit.fitWidth,
                                // width: 228.w,
                                width: 600.w,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 700.h,
                          ),
                          controller.time > 2
                              ? Obx(() => LoadingIndicator(
                                    progress: (controller.value.value / 100),
                                  ))
                              : SizedBox(),
                          SizedBox(
                            height: 25.h,
                          ),
                          controller.time > 2
                              ? Obx(() => Text(
                                    '${controller.value.value.toString()}%',
                                    style: MediumHeaderStyle(),
                                  ))
                              : SizedBox()
                        ],
                      ),
                    ),
                    nextScreen: RootPage()),
              ),
              GetPage(
                  name: '/product',
                  page: () => ProductScreen(),
                  binding: ProductBindings()),
              GetPage(
                  name: '/categories',
                  page: () => CategoriesView(),
                  binding: CategoriesBindings()),
              GetPage(
                  name: '/ar',
                  page: () => ARSessionView(),
                  binding: ARSessionBindings()),
            ],
          );
        });
  }
}

class MyAppController extends GetxController {
  var rng = Random();
  late int time;

  late Timer timer;
  RxInt value = 0.obs;
  @override
  void onInit() {
    progress();
    super.onInit();
  }

  progress() {
    time = rng.nextInt(5);
    timer = Timer.periodic(Duration(milliseconds: time * 10), (t) {
      value++;
      if (value.value == 100) {
        timer.cancel();
        Get.delete<MyAppController>();
      }
    });
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPage = 0;
  late int prevPage;
  final pages = [
    const HomePage(),
    CollectionsView(),
    const CartPage(),
    const SettingsPage()
  ];
  final CartController cartVM = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    // RxInt badge = cartVM.list.length.obs;

    return Scaffold(
      body: Center(child: pages.elementAt(currentPage)),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.w, vertical: 50.h),
            child: ValueListenableBuilder<Box<CartModel>>(
                valueListenable: Boxes.getCart().listenable(),
                builder: (contex, number, _) {
                  return GNav(
                    //hoverColor: const Color.fromARGB(255, 27, 7, 110),
                    //rippleColor: const Color.fromARGB(255, 27, 4, 110),
                    curve: Curves.easeInCirc,
                    duration: const Duration(milliseconds: 100),
                    haptic: true,
                    selectedIndex: currentPage,
                    onTabChange: (index) {
                      setState(() {
                        prevPage = currentPage;
                        currentPage = index;
                        if (prevPage == 1) {
                          if (currentPage != 1) {
                            Get.delete<CollectionsController>();
                            Get.delete<NewCollectionsController>();
                          }
                        }
                        if (currentPage == 1) {
                          Get.put(CollectionsController());
                          Get.put(NewCollectionsController());
                        }
                        if (currentPage == 2) {
                          Get.lazyPut(() => OrderHistoryController());
                        }
                        if (prevPage == 2 && currentPage != 2) {
                          Get.delete<OrderHistoryController>();
                        }
                      });
                    },
                    gap: 20.h,
                    backgroundColor: Colors.white,
                    color: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 45.w, vertical: 20.h),
                    activeColor: Colors.white,
                    tabBackgroundColor: AppColors.secondary,
                    tabs: [
                      const GButton(icon: Icons.home_outlined),
                      const GButton(icon: Ionicons.albums_sharp),
                      GButton(
                        icon: Icons.shopping_basket_outlined,
                        leading: currentPage == 2 || number.isEmpty
                            ? null
                            : badge.Badge(
                                // badgeColor: AppColors.primary,
                                // elevation: 0,
                                badgeStyle: badge.BadgeStyle(
                                    badgeColor: AppColors.primary),
                                position: badge.BadgePosition.topEnd(
                                    top: -12, end: -12),
                                badgeContent: Text(
                                  number.length.toString(),
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontFamily: 'Gotham',
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Icon(
                                  Icons.shopping_basket_outlined,
                                ),
                              ),
                      ),
                      const GButton(icon: Icons.person_outline)
                    ],
                  );
                })),
      ),
    );
  }
}
