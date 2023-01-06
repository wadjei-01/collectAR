import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navbar/mainpages/cart_page/cartmodel.dart';

import '../../collections/collections_controller.dart';

class CartController extends GetxController {
  final box = Boxes.getCart();
  void incrementQuantity(int quantity) => quantity++;
  void decrementQuantity(int quantity) {
    if (quantity > 1) quantity--;
  }

  add(String id, String image, String name, String price, int quantity,
      Color color) {
    var priceValue = price.split('₵');

    if (checkID(id)[0]) {
      box.putAt(
          checkID(id)[1],
          (CartModel(
              id: id,
              image: image,
              name: name,
              price: double.parse(priceValue[1]),
              quantity: quantity,
              color: color.value)));
      // list[checkID(id)[1]] = ;
      print(id);
    } else {
      box.add(CartModel(
          id: id,
          image: image,
          name: name,
          price: double.parse(priceValue[1]),
          quantity: quantity,
          color: color.value));
      print(id);
    }

    update();
  }

  total() {
    double sum = 0;
    for (int i = 0; i < box.length; i++) {
      sum = sum + (box.getAt(i)!.price * box.getAt(i)!.quantity);
    }
    return sum;
  }

  findQuantity(String id) {
    int? quantity;
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i)!.id.contains(id)) {
        print(quantity);
        quantity = box.getAt(i)!.quantity;
      }
    }
    return quantity;
  }

  bool isAddToCart(String id, int quantity) {
    bool boolean = false;
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i)!.id.isCaseInsensitiveContains(id) &&
          quantity == box.getAt(i)!.quantity) boolean = true;
    }
    return boolean;
  }

  List checkID(String id) {
    bool boolean = false;
    int index = 0;
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i)!.id.isCaseInsensitiveContains(id)) {
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
}
