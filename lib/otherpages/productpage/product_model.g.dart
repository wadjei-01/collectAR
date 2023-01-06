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
      price: fields[3] as String,
      stock: fields[4] as int,
      images: (fields[5] as List).cast<dynamic>(),
      bookmarked: fields[6] as bool,
      imageColour: fields[7] as dynamic,
      primaryColour: fields[8] as String,
      secondaryColour: fields[9] as String,
      tetiaryColour: fields[10] as String,
      dateAdded: fields[11] as dynamic,
      category: fields[12] as String,
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
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.stock)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.bookmarked)
      ..writeByte(7)
      ..write(obj.imageColour)
      ..writeByte(8)
      ..write(obj.primaryColour)
      ..writeByte(9)
      ..write(obj.secondaryColour)
      ..writeByte(10)
      ..write(obj.tetiaryColour)
      ..writeByte(11)
      ..write(obj.dateAdded)
      ..writeByte(12)
      ..write(obj.category);
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
