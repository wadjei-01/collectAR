import 'package:flutter/material.dart';
import 'package:navbar/otherpages/productpage/product_model.dart';
import 'package:hive/hive.dart';

import '../box/boxes.dart';
import 'collections_controller.dart';
part 'collections_model.g.dart';

@HiveType(typeId: 1)
class Collections extends HiveObject {
  @HiveField(0)
  String collectionName;
  @HiveField(1)
  int color;
  @HiveField(2)
  List<Product>? products = <Product>[];

  Collections(this.collectionName, this.color);

  addProduct(int index, Product product) {
    // List<Product>? tempProducts = [
    //   ...Boxes.getCollections().getAt(index)!.products!
    // ];
    // tempProducts.add(product);

    // Boxes.getCollections().putAt(index, Collections(products: tempProducts));
    Boxes.getCollections().getAt(index)!.products!.add(product);
    Boxes.getCollections().getAt(index)!.save();
  }

  deleteProduct(int index) {
    Boxes.getCollections().getAt(index)!.products!.removeAt(index);
  }
}
