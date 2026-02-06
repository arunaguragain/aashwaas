import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'volunteer_auth_api_model.g.dart';

@JsonSerializable()
class VolunteerAuthApiModel {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'name')
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? role;
  final String? profilePicture;
  final DateTime? createdAt;

  VolunteerAuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.password,
    this.role,
    this.profilePicture,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    final data = _$VolunteerAuthApiModelToJson(this);
    data.removeWhere((key, value) => value == null);
    return data;
  }

  factory VolunteerAuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$VolunteerAuthApiModelFromJson(json);

  VolunteerAuthEntity toEntity() {
    return VolunteerAuthEntity(
      volunteerAuthId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      createdAt: createdAt,
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
