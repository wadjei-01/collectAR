import 'package:get/get.dart';
import 'package:navbar/firebase/firebaseDB.dart';
import "package:flutter/material.dart";

class OrderHistoryController extends GetxController {
  static final userID = FireStoreDB.auth.currentUser!.uid;
  final firestoreDB = FireStoreDB.firebaseFirestore
      .collection('orders')
      .where("userID", isEqualTo: userID);

  RxBool hasData = false.obs;

  Future<void> checkOrderHistory() async {
    final snapshot = await firestoreDB.get();
    if (snapshot.docs.length != 0) {
      hasData(true);
    } else {
      hasData(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
