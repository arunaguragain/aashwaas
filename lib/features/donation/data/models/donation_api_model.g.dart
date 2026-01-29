// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationApiModel _$DonationApiModelFromJson(Map<String, dynamic> json) =>
    DonationApiModel(
      id: json['_id'] as String?,
      itemName: json['itemName'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      quantity: json['quantity'] as String,
      condition: json['condition'] as String,
      pickupLocation: json['pickupLocation'] as String,
      media: json['media'] as String?,
      donorId: _extractId(json['donorId']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$DonationApiModelToJson(DonationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'itemName': instance.itemName,
      'category': instance.category,
      'description': instance.description,
      'quantity': instance.quantity,
      'condition': instance.condition,
      'pickupLocation': instance.pickupLocation,
      'media': instance.media,
      'donorId': instance.donorId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'status': instance.status,
    };
