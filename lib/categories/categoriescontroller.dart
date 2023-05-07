import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:navbar/categories/categories_model.dart';
import 'package:navbar/firebase/firebaseDB.dart';

import '../cart_page/cartcontroller.dart';

class CategoriesController extends GetxController {
  final int _catNumber = Get.arguments;
  final Categories _categories = Categories();

  String get category => _categories.getCatName(_catNumber)!;
  int get categoryNumber => _catNumber;

  get categoryStream => FireStoreDB.firebaseFirestore
      .collection('store')
      .where("category", arrayContains: _catNumber)
      .get()
      .asStream();

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
