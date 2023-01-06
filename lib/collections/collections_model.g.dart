// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionsAdapter extends TypeAdapter<Collections> {
  @override
  final int typeId = 1;

  @override
  Collections read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Collections(
      fields[0] as String,
      fields[1] as int,
    )..products = (fields[2] as List?)?.cast<Product>();
  }

  @override
  void write(BinaryWriter writer, Collections obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.collectionName)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
