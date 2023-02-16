import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:navbar/box/boxes.dart';

import '../../collections/collections_controller.dart';
import 'cartmodel.dart';

class CartController extends GetxController {
  final box = Boxes.getCart();
  double deliveryFee = 15.0;
  double rate = 0.01;
  void incrementQuantity(int quantity) => quantity++;
  void decrementQuantity(int quantity) {
    if (quantity > 1) quantity--;
  }

  RxBool isExtended = false.obs;

  add(String id, String image, String name, double price, int quantity,
      Color color) {
    if (box.values.firstWhereOrNull(
          (element) => element.id == id,
        ) !=
        null) {
      box.putAt(
          checkID(id)[1],
          (CartModel(
              id: id,
              image: image,
              name: name,
              price: price,
              quantity: quantity,
              color: color.value)));
      // list[checkID(id)[1]] = ;
      print(id);
    } else {
      box.add(CartModel(
          id: id,
          image: image,
          name: name,
          price: price,
          quantity: quantity,
          color: color.value));
      print(id);
    }

    update();
  }

  totalCost() {
    double sum = 0;
    for (int i = 0; i < box.length; i++) {
      sum = sum + (box.getAt(i)!.price * box.getAt(i)!.quantity);
    }
    return sum;
  }

  overallCost() {
    double total = totalCost();
    double overAll = total + (total * rate) + deliveryFee;
    return overAll;
  }

  findQuantity(String id) {
    int? quantity;
    var value = box.values.firstWhereOrNull(
      (element) => element.id == id,
    );
    if (value != null) {
      quantity = value.quantity;
    }

    return quantity;
  }

  bool isAddedToCart(String id, int quantity) {
    bool boolean = false;

    var value = box.values.firstWhereOrNull(
      (element) => element.id == id,
    );

    if (value != null && quantity == value.quantity) {
      boolean = true;
    }

    print(boolean);
    return boolean;
  }

  List checkID(String id) {
    bool boolean = false;
    int index = 0;
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i)!.id.isCaseInsensitiveContains(id)) {
        print(" contains: ${box.values.firstWhereOrNull(
          (element) => element.id == id,
        )}");
        boolean = true;
        index = i;
      }
    }
    return [boolean, index];
  }

  int getItemNum() {
    return box.length;
  }

  del(int index) {
    box.deleteAt(index);
    update();
  }

  extend() {
    isExtended.value = !isExtended.value;
    update();
  }
}
