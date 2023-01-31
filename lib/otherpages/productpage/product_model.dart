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
  final String details;
  @HiveField(4)
  final dynamic materials;
  @HiveField(5)
  final String colorText;
  @HiveField(6)
  final double price;
  @HiveField(7)
  final int stock;
  @HiveField(8)
  final List<dynamic> images;
  @HiveField(9)
  bool bookmarked;
  @HiveField(10)
  final dynamic imageColour;
  @HiveField(11)
  final String primaryColour;
  @HiveField(12)
  final String secondaryColour;
  @HiveField(13)
  final String tetiaryColour;
  @HiveField(14)
  final dynamic dateAdded;
  @HiveField(15)
  final String category;
  @HiveField(16)
  final String modelAR;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.details,
      required this.materials,
      required this.colorText,
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
      required this.modelAR});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'details': details,
        'materials': materials,
        'images': images,
        'bookmarked': bookmarked,
        'imageColour': imageColour,
        'primaryColour': primaryColour,
        'secondaryColour': secondaryColour,
        'tetiaryColour': tetiaryColour,
        'dateAdded': dateAdded,
        'category': category,
        'modelAR': modelAR,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
      id: json['id'],
      name: json['name'],
      colorText: json['colorText'],
      description: json['description'],
      details: json['details'],
      materials: json['materials'],
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
      modelAR: json['modelAR']);
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
