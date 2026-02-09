// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ngo_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NgoApiModel _$NgoApiModelFromJson(Map<String, dynamic> json) => NgoApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      registrationNumber: json['registrationNumber'] as String,
      contactPerson: json['contactPerson'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      focusAreas: (json['focusAreas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      photo: json['photo'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NgoApiModelToJson(NgoApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'registrationNumber': instance.registrationNumber,
      'contactPerson': instance.contactPerson,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'focusAreas': instance.focusAreas,
      'photo': instance.photo,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
