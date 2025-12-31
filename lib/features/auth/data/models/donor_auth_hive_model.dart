import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'donor_auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.donorAuthTypeId)
class DonorAuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? donorAuthId;
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

  DonorAuthHiveModel({
    String? donorAuthId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.password,
    this.profilePicture,
  }) : donorAuthId = donorAuthId ?? Uuid().v4();

  factory DonorAuthHiveModel.fromEntity(DonorAuthEntity entity) {
    return DonorAuthHiveModel(
      donorAuthId: entity.donorAuthId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  DonorAuthEntity toEntity() {
    return DonorAuthEntity(
      donorAuthId: donorAuthId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      profilePicture: profilePicture,
    );
  }

  //To entity List
  static List<DonorAuthEntity> toEntityList(List<DonorAuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
