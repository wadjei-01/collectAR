// import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 2)
class Product {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String price;
  @HiveField(4)
  final int stock;
  @HiveField(5)
  final List<dynamic> images;
  @HiveField(6)
  bool bookmarked;
  @HiveField(7)
  final dynamic imageColour;
  @HiveField(8)
  final String primaryColour;
  @HiveField(9)
  final String secondaryColour;
  @HiveField(10)
  final String tetiaryColour;
  @HiveField(11)
  final dynamic dateAdded;
  @HiveField(12)
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.bookmarked,
    required this.imageColour,
    required this.primaryColour,
    required this.secondaryColour,
    required this.tetiaryColour,
    required this.dateAdded,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'images': images,
        'bookmarked': bookmarked,
        'imageColour': imageColour,
        'primaryColour': primaryColour,
        'secondaryColour': secondaryColour,
        'tetiaryColour': tetiaryColour,
        'dateAdded': dateAdded,
        'category': category,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        stock: json['stock'],
        images: json['images'],
        bookmarked: json['bookmarked'],
        imageColour: json['imageColour'],
        primaryColour: json['primaryColour'],
        secondaryColour: json['secondaryColour'],
        tetiaryColour: json['tetiaryColour'],
        dateAdded: json['dateAdded'],
        category: json['category'],
      );
}

class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final typeId = 16;

  @override
  Timestamp read(BinaryReader reader) {
    final micros = reader.readInt();
    return Timestamp.fromMicrosecondsSinceEpoch(micros);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    writer.writeInt(obj.microsecondsSinceEpoch);
  }
}
