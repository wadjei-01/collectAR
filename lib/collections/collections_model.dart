import 'package:hive/hive.dart';
import '../box/boxes.dart';
import '../productpage/product_model.dart';
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

  //Adds a product to a specific collection using the index
  addProduct(int index, Product product) {
    Boxes.getCollections().getAt(index)!.products!.add(product);
    Boxes.getCollections().getAt(index)!.save();
  }

  //Deletes a product from a specific collection
  deleteProduct(int collectionIndex, int index) {
    Boxes.getCollections().getAt(collectionIndex)!.products!.removeAt(index);
  }
}
