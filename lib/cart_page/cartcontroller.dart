import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:navbar/box/boxes.dart';
import 'cartmodel.dart';

class CartController extends GetxController {
  final cartBox = Boxes.getCart();
  final _deliveryFee = 15.0;
  final _rate = 0.01;

  addProductToCart(String id, String image, String name, double price,
      int quantity, Color color) {
    if (cartBox.values.firstWhereOrNull(
          (element) => element.id == id,
        ) !=
        null) {
      cartBox.putAt(
          checkID(id)[1],
          (CartModel(
              id: id,
              image: image,
              name: name,
              price: price,
              quantity: quantity,
              color: color.value)));
      int value = cartBox.length;

      return value;
    } else {
      cartBox.add(CartModel(
          id: id,
          image: image,
          name: name,
          price: price,
          quantity: quantity,
          color: color.value));
      int value = cartBox.length;

      return null;
    }
  }

  void increaseQuantity(int index, RxInt quantity) {
    quantity.value++;
    addProductToCart(
        cartBox.getAt(index)!.id,
        cartBox.getAt(index)!.image,
        cartBox.getAt(index)!.name,
        cartBox.getAt(index)!.price,
        quantity.value,
        Color(cartBox.getAt(index)!.color));
    update();
  }

  void decreaseQuantity(int index, RxInt quantity) {
    quantity.value--;
    addProductToCart(
        cartBox.getAt(index)!.id,
        cartBox.getAt(index)!.image,
        cartBox.getAt(index)!.name,
        cartBox.getAt(index)!.price,
        quantity.value,
        Color(cartBox.getAt(index)!.color));

    if (quantity.value == 0) {
      deleteProductFromCart(index);
    }
    update();
  }

  String getTotalCost() {
    double sum = 0;
    for (int i = 0; i < cartBox.length; i++) {
      sum = sum + (cartBox.getAt(i)!.price * cartBox.getAt(i)!.quantity);
    }
    return sum.toStringAsFixed(2);
  }

  String getOverallCost() {
    double total = double.parse(getTotalCost());
    double overAll = total + (total * _rate) + _deliveryFee;
    return overAll.toStringAsFixed(2);
  }

  bool isAddedToCart(String id, int quantity) {
    bool boolean = false;

    var value = cartBox.values.firstWhereOrNull(
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
    for (int i = 0; i < cartBox.length; i++) {
      if (cartBox.getAt(i)!.id.isCaseInsensitiveContains(id)) {
        print(" contains: ${cartBox.values.firstWhereOrNull(
          (element) => element.id == id,
        )}");
        boolean = true;
        index = i;
      }
    }
    return [boolean, index];
  }

  int getItemNum() {
    return cartBox.length;
  }

  deleteProductFromCart(int index) {
    cartBox.deleteAt(index);
    update();
  }
}
