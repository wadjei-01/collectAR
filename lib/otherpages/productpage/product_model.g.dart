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
      colorText: fields[5] as String,
      price: fields[6] as double,
      stock: fields[7] as int,
      images: (fields[8] as List).cast<dynamic>(),
      bookmarked: fields[9] as bool,
      imageColour: fields[10] as dynamic,
      primaryColour: fields[11] as String,
      secondaryColour: fields[12] as String,
      tetiaryColour: fields[13] as String,
      dateAdded: fields[14] as dynamic,
      category: fields[15] as String,
      modelAR: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(17)
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
      ..writeByte(5)
      ..write(obj.colorText)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.stock)
      ..writeByte(8)
      ..write(obj.images)
      ..writeByte(9)
      ..write(obj.bookmarked)
      ..writeByte(10)
      ..write(obj.imageColour)
      ..writeByte(11)
      ..write(obj.primaryColour)
      ..writeByte(12)
      ..write(obj.secondaryColour)
      ..writeByte(13)
      ..write(obj.tetiaryColour)
      ..writeByte(14)
      ..write(obj.dateAdded)
      ..writeByte(15)
      ..write(obj.category)
      ..writeByte(16)
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
