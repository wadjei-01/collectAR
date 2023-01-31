import 'package:hive/hive.dart';
import 'package:navbar/models/user_model.dart';
import '../cart_page/cartmodel.dart';
import '../collections/collections_model.dart';

class Boxes {
  static Box<Collections> getCollections() =>
      Hive.box<Collections>('collections');
  static Box<CartModel> getCart() => Hive.box<CartModel>('cart');
  static Box<User> getUser() => Hive.box<User>('user');
}
