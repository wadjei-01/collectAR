import 'package:get/get.dart';
import 'package:navbar/categories/categories_model.dart';
import 'package:navbar/firebase/firebaseDB.dart';

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
}
