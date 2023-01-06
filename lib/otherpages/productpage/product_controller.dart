import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:hive/hive.dart';
import '../../mainpages/cart_page/cartcontroller.dart';
import '../../mainpages/cart_page/cartmodel.dart';
import 'product_model.dart';
import '../globals.dart';
import 'package:navbar/models/user_model.dart' as userModels;

class ProductController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final num;

  void increment() => num.value++;
  void decrement() {
    if (num.value > 1) num.value--;
  }

  final CartController cartVM = Get.put(CartController());
  bool addedToCart = false;
  int? count;
  late Product product;
  var _relatedProducts;

  @override
  void onInit() {
    product = Get.arguments as Product;
    count = cartVM.findQuantity(product.id);
    num = count?.obs ?? 1.obs;
    getData(product);
    super.onInit();
  }

  get relatedProducts => _relatedProducts.value;

  getData(Product product) {
    _relatedProducts = FirebaseFirestore.instance
        .collection('store')
        .where("category", isEqualTo: product.category)
        .where('id', isNotEqualTo: product.id)
        .obs;
    update();
  }

  @override
  void refresh() {
    product = Get.arguments as Product;
    super.refresh();
  }
}
