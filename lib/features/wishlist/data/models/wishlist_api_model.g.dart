// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistApiModel _$WishlistApiModelFromJson(Map<String, dynamic> json) =>
    WishlistApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      category: json['category'] as String,
      plannedDate: json['plannedDate'] as String,
      notes: json['notes'] as String?,
      donorId: _extractId(json['donorId']),
      status: json['status'] == null
          ? WishlistStatus.active
          : _statusFromString(json['status'] as String?),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$WishlistApiModelToJson(WishlistApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'plannedDate': instance.plannedDate,
      'notes': instance.notes,
      'donorId': instance.donorId,
      'status': _statusToString(instance.status),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
