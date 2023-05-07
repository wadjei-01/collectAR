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
  @HiveField(6)
  final dynamic price;
  @HiveField(7)
  final int stock;
  @HiveField(8)
  final List<dynamic> images;
  @HiveField(9)
  final dynamic imageColour;
  @HiveField(10)
  final dynamic dateAdded;
  @HiveField(11)
  final List<dynamic> category;
  @HiveField(12)
  final List<dynamic> measurements;
  @HiveField(13)
  final String modelAR;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.details,
      required this.materials,
      required this.price,
      required this.stock,
      required this.images,
      required this.imageColour,
      required this.dateAdded,
      required this.category,
      required this.modelAR,
      required this.measurements});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'details': details,
        'materials': materials,
        'images': images,
        'imageColour': imageColour,
        'dateAdded': dateAdded,
        'category': category,
        'modelAR': modelAR,
        'measurements': measurements
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      details: json['details'],
      materials: json['materials'],
      price: json['price'],
      stock: json['stock'],
      images: json['images'],
      imageColour: json['imageColour'],
      dateAdded: json['dateAdded'],
      category: json['category'],
      modelAR: json['modelAR'],
      measurements: json['measurements']);
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
