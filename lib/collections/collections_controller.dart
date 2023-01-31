import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:navbar/collections/collections_model.dart';
import 'package:navbar/otherpages/globals.dart';

import '../box/boxes.dart';
import '../otherpages/productpage/product_model.dart';

class CollectionsController extends GetxController {
  late Product? product;

  //A getter for all collections
  List<Collections> get collectionsList =>
      Boxes.getCollections().values.toList();

  //Code here helps create a collection
  TextEditingController collectionName =
      TextEditingController(text: 'Collection Text');

  newCollection(String name, int color) {
    // _collectionsList.add(Collections(name, color));
    final box = Boxes.getCollections();
    box.add(Collections(name, color));

    update();
  }

  @override
  void onInit() {
    product = Get.arguments as Product?;
    super.onInit();
  }

  //Adds products to a collection based on the collection index
  Future<void> addToCollection(int index, Product product) async {
    // var val =
    // // _collectionsList.firstWhere((item) => item.products!.contains(product));
    // print(val);
    final box = Boxes.getCollections();

    if (box.getAt(index)!.products!.isEmpty) {
      box.getAt(index)!.addProduct(index, product);
      print('empty!!');
    } else if (box.getAt(index)!.products!.isNotEmpty) {
      var val = box
          .getAt(index)!
          .products!
          .firstWhereOrNull((element) => element.name == product.name);

      if (val == null) {
        box.getAt(index)!.addProduct(index, product);
      } else {
        Get.snackbar("Relax!", "This product has already been added",
            animationDuration: Duration(milliseconds: 750),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.primary);
      }
    }

    update();
  }

  Future<void> deleteProduct(int collectionIndex, int productIndex) async {
    final box = Boxes.getCollections();
    box.getAt(collectionIndex)!.deleteProduct(productIndex);
    update();
  }

  int get collectionSize => Boxes.getCollections().length;
  RxInt collectionProductSize(int index) =>
      Boxes.getCollections().getAt(index)!.products!.length.obs;

  void deleteCollection(int index) {
    Boxes.getCollections().deleteAt(index);
    update();
  }

  @override
  void dispose() {
    Hive.box('collections').close();
    super.dispose();
  }
}

class NewCollectionsController extends GetxController {
  // RxString collectionName = ''.obs; // observable String
  // final collectionList = Get.find<CollectionsController>()._collectionsList;

  TextEditingController textController = TextEditingController();
  late Color screenPickerColor;

  List<Color> colorList = [
    HexColor('F90020'),
    HexColor('FABC1F'),
    HexColor('339936'),
    HexColor('3334E7'),
    HexColor('5C139F'),
  ];

  RxInt selected = 0.obs;
  OnTap(int index) {
    selected.value = index;
    screenPickerColor = colorList[index];
    update();
  }

  @override
  void onInit() {
    screenPickerColor = colorList[0];

    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void reset() {
    textController.text = '';
    selected.value = 0;
    screenPickerColor = colorList[0];
  }
}
