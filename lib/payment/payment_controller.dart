import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:navbar/models/user_model.dart' as userModel;
import 'package:navbar/cart_page/cartcontroller.dart';
import 'package:navbar/cart_page/cartmodel.dart';
import 'package:navbar/firebase/firebaseDB.dart';
import 'package:navbar/main.dart';

import '../orders/orders_model.dart';
import 'dart:math';

class PaymentController extends GetxController {
  RxBool isExtended = false.obs;
  static String oID = '';
  static FirebaseAuth auth = FireStoreDB.auth;
  static final _cartItems = Get.find<CartController>();
  FirebaseFirestore firestore = FireStoreDB.firebaseFirestore;
  extend() {
    isExtended(!isExtended.value);
    print(isExtended.value);
    update();
  }

  static addToFB() async {
    String randomize = getRandomString(3);
    String day = DateTime.now().day.toString();
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString().substring(2, 4);
    String hour = DateTime.now().hour.toString();
    String minute = DateTime.now().minute.toString();
    userModel.User userDets = box.get('user');
    oID = auth.currentUser!.uid.substring(0, 5) +
        randomize +
        "-" +
        day +
        month +
        year +
        "-" +
        hour +
        "-" +
        minute;

    Orders orders = Orders(
        orderID: oID,
        userID: auth.currentUser!.uid,
        userLocation: userDets.location,
        name: '${userDets.firstName} ${userDets.lastName}',
        items: _cartItems.box.toMap().values.toList(),
        status: Status.pending,
        date: Timestamp.now());
    await FireStoreDB.firebaseFirestore
        .collection('orders')
        .add(orders.toJson());
  }

  static String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
