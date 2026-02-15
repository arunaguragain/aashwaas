// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskHiveModelAdapter extends TypeAdapter<TaskHiveModel> {
  @override
  final int typeId = 4;

  @override
  TaskHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskHiveModel(
      taskId: fields[0] as String?,
      title: fields[1] as String,
      donationId: fields[2] as String?,
      volunteerId: fields[3] as String?,
      ngoId: fields[4] as String?,
      status: fields[5] as String?,
      assignedAt: fields[6] as DateTime?,
      acceptedAt: fields[7] as DateTime?,
      completedAt: fields[8] as DateTime?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.donationId)
      ..writeByte(3)
      ..write(obj.volunteerId)
      ..writeByte(4)
      ..write(obj.ngoId)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.assignedAt)
      ..writeByte(7)
      ..write(obj.acceptedAt)
      ..writeByte(8)
      ..write(obj.completedAt)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
