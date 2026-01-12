import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';

class VolunteerAuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? role;
  final String? profilePicture;

  VolunteerAuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.password,
    this.role,
    this.profilePicture,
  });

  //toJSON
  Map<String, dynamic> toJson() {
    return {
      "name": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
      "role": role,
      "profilePicture": profilePicture,
    };
  }

  //fromJson
  factory VolunteerAuthApiModel.fromJson(Map<String, dynamic> json) {
    return VolunteerAuthApiModel(
      id: json['_id'] as String,
      fullName: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  VolunteerAuthEntity toEntity() {
    return VolunteerAuthEntity(
      volunteerAuthId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );
  }

  //fromEntity
  factory VolunteerAuthApiModel.fromEntity(VolunteerAuthEntity entity) {
    return VolunteerAuthApiModel(
      // id: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
      password: entity.password,
      // role: entity.role;
    );
  }

  //toEntityList
  static List<VolunteerAuthEntity> toEntityList(
    List<VolunteerAuthApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
