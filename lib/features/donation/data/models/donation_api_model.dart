import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'donation_api_model.g.dart';

/// Helper to extract ID from nested object or string
String? _extractId(dynamic value) {
  if (value == null) return null;
  if (value is Map) return value['_id'] as String?;
  return value as String?;
}

@JsonSerializable()
class DonationApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String itemName;
  final String category;
  final String? description;
  final String quantity;
  final String condition;
  final String pickupLocation;
  final String? media;
  @JsonKey(fromJson: _extractId)
  final String? donorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;

  DonationApiModel({
    this.id,
    required this.itemName,
    required this.category,
    this.description,
    required this.quantity,
    required this.condition,
    required this.pickupLocation,
    this.media,
    this.donorId,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  Map<String, dynamic> toJson() => _$DonationApiModelToJson(this);

  factory DonationApiModel.fromJson(Map<String, dynamic> json) =>
      _$DonationApiModelFromJson(json);

  DonationEntity toEntity() {
    return DonationEntity(
      donationId: id,
      itemName: itemName,
      category: category,
      description: description,
      quantity: quantity,
      condition: condition,
      pickupLocation: pickupLocation,
      media: media,
      donorId: donorId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
    );
  }

  factory DonationApiModel.fromEntity(DonationEntity entity) {
    return DonationApiModel(
      id: entity.donationId,
      itemName: entity.itemName,
      category: entity.category,
      description: entity.description,
      quantity: entity.quantity,
      condition: entity.condition,
      pickupLocation: entity.pickupLocation,
      media: entity.media,
      donorId: entity.donorId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      status: entity.status,
    );
  }

  static List<DonationEntity> toEntityList(List<DonationApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
