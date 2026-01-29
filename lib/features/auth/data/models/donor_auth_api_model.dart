import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'donor_auth_api_model.g.dart';

@JsonSerializable()
class DonorAuthApiModel {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'name')
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
    this.profilePicture,
  });

  Map<String, dynamic> toJson() => _$DonorAuthApiModelToJson(this);

  factory DonorAuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$DonorAuthApiModelFromJson(json);

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
