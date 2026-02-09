// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonorAuthApiModel _$DonorAuthApiModelFromJson(Map<String, dynamic> json) =>
    DonorAuthApiModel(
      id: json['_id'] as String?,
      fullName: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String?,
      profilePicture: json['profilePicture'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DonorAuthApiModelToJson(DonorAuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'role': instance.role,
      'profilePicture': instance.profilePicture,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
