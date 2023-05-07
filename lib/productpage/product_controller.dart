import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import '../../box/boxes.dart';
import '../../cart_page/cartcontroller.dart';
import '../../cart_page/cartmodel.dart';
import '../../collections/collections_controller.dart';
import 'package:collection/collection.dart';
import 'product_model.dart';
import 'package:navbar/models/user_model.dart' as userModels;

class ProductController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final box = Boxes.getCart();
  RxInt quantity = 1.obs;
  RxBool isAdded = false.obs;
  Product product = Get.arguments;
  List<Product> productList = [];

  final cart = Get.find<CartController>();

  var _relatedProducts;
  get relatedProducts => _relatedProducts.value;

  @override
  void onInit() {
    sortData(product);
    super.onInit();
  }

  /**
   * increases the quantity if the value is less than 25 then checks to see if the product has the same quantity 
   * was added to cart
   * */
  void increment() {
    if (quantity.value < 25) quantity.value++;
    checkProduct();
    update();
  }

  /**
   * decreases the quantity if the value is greater than 1 then checks to see if the product has the same quantity 
   * was added to cart
   * */
  void decrement() {
    if (quantity.value > 1) quantity.value--;
    checkProduct();
    update();
  }

  //Goes through the user's cart to check if the product and the specified quantity is in the cart
  checkProduct() {
    if (cart.isAddedToCart(product.id, quantity.value)) {
      isAdded(true);
    } else {
      isAdded(false);
    }
    update();
  }

  //checks the cart for a product using the product ID
  getQuantity(String id) {
    CartModel? value =
        box.values.firstWhereOrNull((element) => element.id == id);
    // if the product is not in the cart, the quantity return would be 1
    if (value == null) {
      quantity(1);
    }

    /// if the product is in the cart, the quantity chosen by the user would be retrieved and assigned to [quantity]
    else {
      quantity(value.quantity);
    }
    update();
  }

  /** sortData method uses the information retrieved from the product to
  * obtain the quantity of the product if it was added to cart, add the product to productList
  * and finally fetch related products from firebase
  */
  sortData(Product product) {
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

  Icon switchIcons(String id) {
    final cartcontroller = Get.find<CartController>();
    final value = cartcontroller.checkID(id)[0];
    if (value == true) {
      return const Icon(
        Ionicons.close,
        color: Colors.white,
      );
    } else {
      return const Icon(
        Ionicons.cart_outline,
        color: Colors.white,
      );
    }
  }
}
