// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolunteerAuthApiModel _$VolunteerAuthApiModelFromJson(
        Map<String, dynamic> json) =>
    VolunteerAuthApiModel(
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

Map<String, dynamic> _$VolunteerAuthApiModelToJson(
        VolunteerAuthApiModel instance) =>
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
