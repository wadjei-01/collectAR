import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../otherpages/productpage/product_model.dart';
import '../otherpages/productpage/product_view.dart';

class HomePageController extends GetxController {
  List<String> tabs = ['All', 'Popular', 'Top Rated', 'Latest'];
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
  late Product store;
  RefreshController refreshController = RefreshController();

  static const _perPage = 10;
  RxBool allFetched = false.obs;
  RxBool isLoading = false.obs;
  final List<Product> data = [];
  DocumentSnapshot? _lastDocument;
  late Query query;

  reset() async {
    data.clear();

    if (!(identical(tabSelection, 'All'))) {
      print(tabSelection);
      query = FirebaseFirestore.instance
          .collection("store")
          .where('tags', arrayContains: tabSelection);
      update();
      print('changed');
    } else {
      query = FirebaseFirestore.instance.collection("store");
      update();
    }

    allFetched(false);
    isLoading(false);
    _lastDocument = null;
    update();

    fetchFirebaseData();
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
    update();
    // refreshController.loadComplete();
  }

  Future<void> fetchFirebaseData() async {
    if (allFetched.isFalse) {
      if (isLoading.isTrue) {}

      isLoading(true);
      update();

      if (_lastDocument != null) {
        query = query
            // .where('category', isEqualTo: tabSelection)
            .startAfterDocument(_lastDocument!)
            .limit(_perPage);
      } else {
        query = query.limit(_perPage);
      }

      final List<Product> pagedData = await query.get().then((value) {
        if (value.docs.isNotEmpty) {
          _lastDocument = value.docs.last;
          //print('something');
        } else {
          // print('empty');
          _lastDocument = null;
        }
        return value.docs
            .map((e) => Product.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      });

      if ((pagedData.length < _perPage)) {
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
}
