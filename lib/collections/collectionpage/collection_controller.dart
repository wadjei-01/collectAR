import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navbar/cart_page/cartcontroller.dart';
import 'package:navbar/collections/collections_model.dart';

import '../../box/boxes.dart';
import '../../productpage/product_model.dart';
import '../../theme/globals.dart';

class CollectionController extends GetxController {
  final Rx<Collections?> _collection = Rx<Collections?>(null);

  Collections? get collection => _collection.value;

  assignCollection(int collectionIndex) {
    _collection(Boxes.getCollections().getAt(collectionIndex));
  }

  deleteProduct(int collectionIndex, int index) {
    _collection.value!.products!.removeAt(index);
    update();
  }

  void addCollectionToCart() {
    final cartController = Get.find<CartController>();
    _collection.value!.products!.forEach((element) {
      cartController.addProductToCart(element.id, element.images[0],
          element.name, element.price, 1, HexColor(element.imageColour));
    });

    Get.snackbar(
      "Added to cart!",
      "The items in this collection have been added to cart",
      snackPosition: SnackPosition.TOP,
      borderRadius: 20.r,
    );
  }
}
