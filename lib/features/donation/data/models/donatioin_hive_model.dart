import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/data/models/donation_api_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'donatioin_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.donationTypeId)
class DonationHiveModel extends HiveObject {
  @HiveField(0)
  final String? donationId;

  @HiveField(1)
  final String itemName;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String quantity;

  @HiveField(5)
  final String condition;

  @HiveField(6)
  final String pickupLocation;

  @HiveField(7)
  final String? media;

  @HiveField(8)
  final String? donorId;

  @HiveField(9)
  final String? status;

  DonationHiveModel({
    String? donationId,
    required this.itemName,
    required this.category,
    this.description,
    required this.quantity,
    required this.condition,
    required this.pickupLocation,
    this.media,
    this.donorId,
    String? status,
  }) : donationId = donationId ?? const Uuid().v4(),
       status = status ?? 'pending';

  factory DonationHiveModel.fromEntity(DonationEntity entity) {
    return DonationHiveModel(
      donationId: entity.donationId,
      itemName: entity.itemName,
      category: entity.category,
      description: entity.description,
      quantity: entity.quantity,
      condition: entity.condition,
      pickupLocation: entity.pickupLocation,
      media: entity.media,
      donorId: entity.donorId,
      status: entity.status,
    );
  }

  DonationEntity toEntity() {
    return DonationEntity(
      donationId: donationId,
      itemName: itemName,
      category: category,
      description: description,
      quantity: quantity,
      condition: condition,
      pickupLocation: pickupLocation,
      media: media,
      donorId: donorId,
      createdAt: DateTime.now(),
      status: status,
    );
  }

  
  static List<DonationEntity> toEntityList(List<DonationHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// Convert from API model to Hive model for caching
  factory DonationHiveModel.fromApiModel(DonationApiModel apiModel) {
    return DonationHiveModel(
      donationId: apiModel.id,
      itemName: apiModel.itemName,
      category: apiModel.category,
      description: apiModel.description,
      quantity: apiModel.quantity,
      condition: apiModel.condition,
      pickupLocation: apiModel.pickupLocation,
      media: apiModel.media,
      donorId: apiModel.donorId,
      status: apiModel.status,
    );
  }

  /// Convert list of API models to Hive models for caching
  static List<DonationHiveModel> fromApiModelList(
    List<DonationApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => DonationHiveModel.fromApiModel(model))
        .toList();
  }
}
