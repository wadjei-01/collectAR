import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/cart_page/cartcontroller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../productpage/product_model.dart';

class HomePageController extends GetxController {
  List<String> tabs = ['All', 'Popular', 'Top Rated', 'Latest'];

  RxInt activeCarourselIndex = 0.obs;

  final imageList = [
    "assets/images/categories/Accent.png",
    "assets/images/categories/Bedroom.png",
    "assets/images/categories/Desks.png",
    "assets/images/categories/Home Office.png",
    "assets/images/categories/Kids.png",
    "assets/images/categories/Outdoor.png",
    "assets/images/categories/Seating.png",
    "assets/images/categories/Wardrobes.png",
    "assets/images/categories/Tables.png",
  ];

  late String tabSelection;
  int selected = 0;
  @override
  void onInit() {
    tabSelection = tabs[0];
    query = FirebaseFirestore.instance.collection("store");
    fetchFirebaseData();
    super.onInit();
  }

  final user = FirebaseAuth.instance.currentUser!;

  late List<Product> storedProducts = [];
  RefreshController refreshController = RefreshController();

  static const _perPage = 10;
  RxBool allFetched = false.obs;
  RxBool isLoading = false.obs;
  final List<Product> data = [];
  DocumentSnapshot? _lastDocument;
  late Query query;

  final carouselController = CarouselController();

  Future<void> reset() async {
    data.clear();

    query = FirebaseFirestore.instance.collection("store");
    if (!(identical(tabSelection, 'All'))) {
      query = query.where('tags', arrayContains: tabSelection);
    }

    allFetched(false);
    isLoading(false);
    _lastDocument = null;
    update();

    await fetchFirebaseData();
    refreshController.refreshCompleted();
    update();
  }

  Future<void> fetchFirebaseData() async {
    if (allFetched.isFalse) {
      if (isLoading.isTrue) return;

      isLoading(true);
      update();

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!).limit(_perPage);
      } else {
        query = query.limit(_perPage);
      }

      final pagedData = await query.get().then((value) {
        _lastDocument = value.docs.isNotEmpty ? value.docs.last : null;
        return value.docs
            .map((e) => Product.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      });

      if (pagedData.length < _perPage) {
        allFetched(true);
      } else {
        data.addAll(pagedData);
      }

      isLoading(false);
      update();
    }
  }

  bool nextPage(ScrollEndNotification scrollEnd) {
    if (scrollEnd.metrics.atEdge && scrollEnd.metrics.pixels > 0) {
      fetchFirebaseData();
      update();
    }

    return true;
  }

  switchCategory(int index) {
    selected = index;
    tabSelection = tabs[index];
    print(tabSelection);

    reset();
  }

  Icon switchIcons(String id) {
    final cartcontroller = Get.find<CartController>();
    final value = cartcontroller.checkID(id)[0];
    if (value == true) {
      return Icon(
        Ionicons.close,
        color: Colors.white,
      );
    } else {
      return Icon(
        Ionicons.cart_outline,
        color: Colors.white,
      );
    }
  }
}
