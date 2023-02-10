import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:badges/badges.dart' as badge;
// import 'package:badges/badges.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:navbar/categories/categoriesview.dart';
import 'package:navbar/collections/collection_page.dart';
import 'package:navbar/collections/collections_model.dart';
import 'package:navbar/collections/collections_view.dart';
import 'package:navbar/homepage/homepage.dart';
import 'package:navbar/otherpages/globals.dart';
import 'package:navbar/otherpages/productpage/product_bindings.dart';
import 'package:navbar/otherpages/productpage/product_view.dart';
import 'package:navbar/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'auth/rootpage.dart';
import 'package:navbar/mainpages/menu_page/menu_page.dart';
import 'package:navbar/mainpages/profile_page/profile_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
// import 'package:badges/src/badge.dart';

import 'box/boxes.dart';
import 'cart_page/cart_page.dart';
import 'cart_page/cartcontroller.dart';
import 'cart_page/cartmodel.dart';
import 'categories/categories_binding.dart';
import 'collections/collections_controller.dart';
import 'models/user_model.dart';
import 'order_history/order_history_controller.dart';
import 'orders/orders_view.dart';
import 'otherpages/productpage/product_model.dart';

late Box box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CollectionsAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartModelAdapter());
  Hive.registerAdapter(TimestampAdapter());
  box = await Hive.openBox('user');
  await Hive.openBox<Collections>('collections');
  await Hive.openBox<CartModel>('cart');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,

    //color set to transparent or set your own color
    statusBarIconBrightness: Brightness.dark,
    //set brightness for icons, like dark background light icons
  )); // transparent status bar
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    splash: SvgPicture.asset(
                      'assets/images/collectAR (text).svg',
                      width: 129.w,
                      height: 339.h,
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
            ],
          );
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
    const ProfilePage()
  ];
  final CartController cartVM = Get.put(CartController());
  final OrderHistoryController orderHistoryController =
      Get.put(OrderHistoryController());

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
                        if (prevPage == 1) {
                          Get.delete<CollectionsController>();
                          Get.delete<NewCollectionsController>();
                        }
                        currentPage = index;
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
                      const GButton(icon: Icons.menu),
                      GButton(
                        icon: Icons.shopping_basket_outlined,
                        leading: currentPage == 2 || number.isEmpty
                            ? null
                            : badge.Badge(
                                badgeColor: AppColors.primary,
                                elevation: 0,
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
