// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistHiveModelAdapter extends TypeAdapter<WishlistHiveModel> {
  @override
  final int typeId = 3;

  @override
  WishlistHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistHiveModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      category: fields[2] as String,
      plannedDate: fields[3] as String,
      notes: fields[4] as String?,
      donorId: fields[5] as String,
      status: fields[6] as WishlistStatus,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.plannedDate)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.donorId)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
