import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'cartmodel.g.dart';

@HiveType(typeId: 3)
class CartModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String image;
  @HiveField(3)
  int quantity;
  @HiveField(4)
  double price;
  @HiveField(5)
  int color;

  CartModel(
      {required this.id,
      required this.image,
      required this.name,
      required this.price,
      required this.quantity,
      required this.color});

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json['id'] as String,
        name: json['name'] as String,
        image: json['image'] as String,
        quantity: json['quantity'] as int,
        price: json['price'],
        color: json['color'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['quantity'] = quantity;
    data['price'] = price;
    data['color'] = color;
    return data;
  }
}
