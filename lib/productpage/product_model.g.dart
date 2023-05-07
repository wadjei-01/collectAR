// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 2;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      details: fields[3] as String,
      materials: fields[4] as dynamic,
      price: fields[6] as dynamic,
      stock: fields[7] as int,
      images: (fields[8] as List).cast<dynamic>(),
      imageColour: fields[9] as dynamic,
      dateAdded: fields[10] as dynamic,
      category: (fields[11] as List).cast<dynamic>(),
      modelAR: fields[13] as String,
      measurements: (fields[12] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.details)
      ..writeByte(4)
      ..write(obj.materials)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.stock)
      ..writeByte(8)
      ..write(obj.images)
      ..writeByte(9)
      ..write(obj.imageColour)
      ..writeByte(10)
      ..write(obj.dateAdded)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.measurements)
      ..writeByte(13)
      ..write(obj.modelAR);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
