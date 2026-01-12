import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';

class DonorAuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? role;
  final String? profilePicture;

  DonorAuthApiModel({
    this.id, 
    required this.fullName, 
    required this.email, 
    this.phoneNumber, 
    this.password, 
    this.role, 
    this.profilePicture
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
  factory DonorAuthApiModel.fromJson(Map<String, dynamic> json) {
    return DonorAuthApiModel(
      id: json['_id'] as String,
      fullName: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  DonorAuthEntity toEntity() {
    return DonorAuthEntity(
      donorAuthId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );
  }

  //fromEntity
  factory DonorAuthApiModel.fromEntity(DonorAuthEntity entity) {
    return DonorAuthApiModel(
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
  static List<DonorAuthEntity> toEntityList(List<DonorAuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
