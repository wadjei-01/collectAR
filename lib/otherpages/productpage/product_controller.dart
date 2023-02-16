import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:hive/hive.dart';
import '../../box/boxes.dart';
import '../../cart_page/cartcontroller.dart';
import '../../cart_page/cartmodel.dart';
import '../../collections/collections_controller.dart';
import 'package:collection/collection.dart';
import 'product_model.dart';
import '../globals.dart';
import 'package:navbar/models/user_model.dart' as userModels;

class ProductController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final box = Boxes.getCart();
  RxInt quantity = 1.obs;
  RxBool isAdded = false.obs;
  Product product = Get.arguments;
  List<Product> productList = [];

  var _relatedProducts;

  @override
  void onInit() {
    getData(product);
    super.onInit();
  }

  void increment() {
    quantity.value++;
    checkProduct();
    update();
  }

  void decrement() {
    if (quantity.value > 1) quantity.value--;
    checkProduct();
    update();
  }

  checkProduct() {
    if (cart.isAddedToCart(product.id, quantity.value)) {
      isAdded.value = true;
    } else {
      isAdded.value = false;
    }
    update();
  }

  getQuantity(String id) {
    CartModel? value =
        box.values.firstWhereOrNull((element) => element.id == id);
    if (value == null) {
      quantity(1);
    } else {
      quantity(value.quantity);
    }
    update();
  }

  final cart = Get.find<CartController>();

  get relatedProducts => _relatedProducts.value;

  getData(Product product) {
    getQuantity(product.id);
    productList.add(product);
    checkProduct();
    _relatedProducts = FirebaseFirestore.instance
        .collection('store')
        .where("category", arrayContains: product.category[0])
        .where('id', isNotEqualTo: product.id)
        .obs;
    update();
  }
}
