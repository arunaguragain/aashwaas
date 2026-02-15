// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskApiModel _$TaskApiModelFromJson(Map<String, dynamic> json) => TaskApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      donationId: _extractId(json['donationId']),
      volunteerId: _extractId(json['volunteerId']),
      ngoId: _extractId(json['ngoId']),
      status: json['status'] == null
          ? TaskStatus.assigned
          : _statusFromString(json['status'] as String?),
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.parse(json['assignedAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TaskApiModelToJson(TaskApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'donationId': instance.donationId,
      'volunteerId': instance.volunteerId,
      'ngoId': instance.ngoId,
      'status': _statusToString(instance.status),
      'assignedAt': instance.assignedAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
