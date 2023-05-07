import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:navbar/collections/collections_model.dart';

import '../box/boxes.dart';
import '../theme/globals.dart';
import '../productpage/product_model.dart';
import 'collectionpage/collection_page.dart';

class CollectionsController extends GetxController {
  late Product? product;
  //_box is declared and assigned all the variables
  final _box = Boxes.getCollections();

  //Retrieves all collections stored on device and assigns it to the collectionList variable
  List<Collections> get collectionsList => _box.values.toList();

  //Returns the number of collections
  int get collectionSize => _box.length;

  //Returns the number of products in a particular collection
  RxInt collectionProductSize(int index) =>
      _box.getAt(index)!.products!.length.obs;

  //Creates a new Collection with the name and user selected color
  void newCollection(String name, int color) {
    _box.add(Collections(name, color));

    update();
  }

  @override
  void onInit() {
    /*If the user opens the Collection page from the Product Page, an object of the product 
    they recently looked at would be assigned to the product variale, else product would be null*/
    product = Get.arguments as Product?;

    super.onInit();
  }

  void onTap(int index) {
    if (product != null) {
      addToCollection(index, product!);
    } else {
      Get.to(
        () => CollectionPage(
          collectionIndex: index,
        ),
      );
    }
  }

  //Adds products to a collection based on the collection index
  Future<void> addToCollection(int index, Product product) async {
    //Product is added if the specific collection is empty
    if (_box.getAt(index)!.products!.isEmpty) {
      _box.getAt(index)!.addProduct(index, product);
      print('empty!!');
    }
    //Else the product is added if said product has not already been added to the collection
    else if (_box.getAt(index)!.products!.isNotEmpty) {
      var val = _box
          .getAt(index)!
          .products!
          .firstWhereOrNull((element) => element.name == product.name);

      if (val == null) {
        _box.getAt(index)!.addProduct(index, product);
      } else {
        Get.snackbar(
          "Relax!",
          "This product has already been added",
          animationDuration: Duration(milliseconds: 750),
          duration: Duration(seconds: 2),
        );
      }
    }

    update();
  }

  void deleteCollection(int index) {
    _box.deleteAt(index);
    update();
  }

  @override
  void dispose() {
    _box.close();
    super.dispose();
  }
}
