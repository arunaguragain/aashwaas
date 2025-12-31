import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'volunteer_auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.volunteerAuthTypeId)
class VolunteerAuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? volunteerAuthId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? phoneNumber;
  @HiveField(4)
  final String? password;
  @HiveField(5)
  final String? profilePicture;

  VolunteerAuthHiveModel({
    String? volunteerAuthId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.password,
    this.profilePicture,
  }) : volunteerAuthId = volunteerAuthId ?? Uuid().v4();

  factory VolunteerAuthHiveModel.fromEntity(VolunteerAuthEntity entity) {
    return VolunteerAuthHiveModel(
      volunteerAuthId: entity.volunteerAuthId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  VolunteerAuthEntity toEntity() {
    return VolunteerAuthEntity(
      volunteerAuthId: volunteerAuthId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      profilePicture: profilePicture,
    );
  }

  //To entity List
  static List<VolunteerAuthEntity> toEntityList(List<VolunteerAuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
