import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navbar/cart_page/cartmodel.dart';

class Orders {
  String orderID;
  String name;
  String userID;
  String userLocation;
  List<CartModel> items;
  Status status;
  Timestamp date;
  double total;

  Orders(
      {required this.orderID,
      required this.name,
      required this.userID,
      required this.userLocation,
      required this.items,
      required this.status,
      required this.date,
      required this.total});

  Map<String, dynamic> toJson() => {
        "orderID": orderID,
        "name": name,
        "userID": userID,
        "userLocation": userLocation,
        "items": items.map((e) => e.toJson()).toList(),
        "status": status.toJson(),
        "date": date,
        "total": total
      };

  static Orders fromJson(Map<String, dynamic> jsonData) => Orders(
      orderID: jsonData['orderID'],
      userID: jsonData['userID'],
      userLocation: jsonData['userLocation'],
      name: jsonData['name'],
      items: jsonData['items']
          .map<CartModel>((cartItems) => CartModel.fromJson(cartItems))
          .toList(),
      status: Status.fromJson(jsonData['status']),
      date: jsonData['date'],
      total: jsonData['total']);
}

enum Status {
  pending,
  declined,
  onRoute,
  accepted,
  delivered;

  String toJson() => name;
  static Status fromJson(String json) => values.byName(json);
}
