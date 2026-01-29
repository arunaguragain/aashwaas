// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donatioin_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DonationHiveModelAdapter extends TypeAdapter<DonationHiveModel> {
  @override
  final int typeId = 2;

  @override
  DonationHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DonationHiveModel(
      donationId: fields[0] as String?,
      itemName: fields[1] as String,
      category: fields[2] as String,
      description: fields[3] as String?,
      quantity: fields[4] as String,
      condition: fields[5] as String,
      pickupLocation: fields[6] as String,
      media: fields[7] as String?,
      donorId: fields[8] as String?,
      status: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DonationHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.donationId)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.condition)
      ..writeByte(6)
      ..write(obj.pickupLocation)
      ..writeByte(7)
      ..write(obj.media)
      ..writeByte(8)
      ..write(obj.donorId)
      ..writeByte(9)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonationHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
