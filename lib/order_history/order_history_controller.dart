import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:navbar/firebase/firebaseDB.dart';
import "package:flutter/material.dart";

class OrderHistoryController extends GetxController {
  late String? userID;
  late Query<Map<String, dynamic>> firestoreDB;

  RxBool hasData = false.obs;

  Future<void> checkOrderHistory() async {
    final snapshot = await firestoreDB.get();
    if (snapshot.docs.length != 0) {
      hasData(true);
    } else {
      hasData(false);
    }
    update();
  }

  void fetchData() {
    userID = FireStoreDB.auth.currentUser!.uid;
    firestoreDB = FireStoreDB.firebaseFirestore
        .collection('orders')
        .where("userID", isEqualTo: userID)
        .orderBy("date", descending: true);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    fetchData();
    super.onInit();
  }
}
